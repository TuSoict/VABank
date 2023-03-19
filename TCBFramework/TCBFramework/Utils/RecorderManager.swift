import UIKit
import AVFoundation
import Accelerate
//import WakeupWord
import Starscream
import RxSwift

enum RecorderState {
    case recording
    case stopped
    case denied
}

protocol SocketProtocol {
    func startRecording()
    func finishRecording()
    func stopSocket()
    func startWakeup()
    func onBuffer(buffer: AVAudioPCMBuffer, voiceAssistantState: VoiceAssistantState)
}

class SocketManager: WebSocketDelegate {
    var isConnected = false
    var socket: WebSocket!
    
    let event: ((AssistantEvent) -> Void)
    
    init(_ completionHandler: @escaping (AssistantEvent) -> Void) {
        event = completionHandler
    }
    
    internal func startWakeup() {
        startWebsocket()
        event(.onWakeup)
    }
    
    private func toData(buffer: AVAudioPCMBuffer) -> Data {
        guard let data = buffer.int16ChannelData else { return Data() }
        let channelCount = 1 // Given PCMBuffer channel count is 1
        let channels = UnsafeBufferPointer(start: data, count: channelCount)
        let ch0Data = NSData(bytes: channels[0], length: Int(buffer.frameCapacity * buffer.format.streamDescription.pointee.mBytesPerFrame)) as Data
        return ch0Data
    }
    
    private func startWebsocket() {
        var request = URLRequest(url: URL(string: NetworkAdapter.shared.environment.webSocketUrl)!)
        request.timeoutInterval = 6 // Sets the timeout for the connection
        request.setValue(NetworkAdapter.shared.appToken?.accessToken ?? "", forHTTPHeaderField: "token")
        request.setValue(NetworkAdapter.shared.appToken?.deviceID ?? "", forHTTPHeaderField: "device_id")
        request.setValue(NetworkAdapter.shared.session_id ?? "", forHTTPHeaderField: "session_id")
        request.setValue("false", forHTTPHeaderField: "forward_message")
        //request.setValue("permessage-deflate", forHTTPHeaderField: "Sec-WebSocket-Extensions")
        
        NetworkAdapter.shared.currentSessionId = NetworkAdapter.shared.session_id
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        Log.debug(message: "socket event \(event)")
        switch event {
        case .connected:
            isConnected = true
        case .disconnected:
            isConnected = false
        case .text(let string):
            self.convertAndResponse(responseString: string)
        case .binary:
            break
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged:
            self.updateStateSocket()
            break
        case .reconnectSuggested(let value):
            if value {
                socket.forceDisconnect()
                socket.connect()
            }
        case .cancelled:
            self.updateStateSocket()
            isConnected = false
        case .error(let error):
            self.updateStateSocket()
            isConnected = false
            Log.debug(message: "\(error?.localizedDescription ?? "")")
        }
    }
    
    private func convertAndResponse(responseString: String) {
        let data = AssistantClient.convertResponseToObject(jsonString: responseString)
        let sttReceivedModel = SpeechToTextReceived(JSON: data)
        let text = sttReceivedModel?.text ?? ""
        let partial = sttReceivedModel?.partial ?? ""
        
        // sau khi người dùng nói xong một câu, nhận được dữ liệu text → thực hiện ngắt kết nối với WebSocket
        if !partial.isEmpty {
            event(.receiveTranscript(message: partial, isFinal: false))
        }
        if !text.isEmpty {
            event(.receiveTranscript(message: text, isFinal: true))
            stopSocket()
        }
    }
    
    private func updateStateSocket() {
        event(.stateSocket)
    }
}

extension SocketManager: SocketProtocol {
    func startRecording() {
        let data: String = Resouces.getHeyVinHomeFile(vinhomeBundleFile: .data)
        let info: String = Resouces.getHeyVinHomeFile(vinhomeBundleFile: .info)
        //SetLogLevel(0);
        
#if DEBUG
        if FileManager.default.fileExists(atPath: data) {
            NSLog("The file exists!")
        } else {
            NSLog("Better luck next time...")
        }
#endif
        
        //CreateWakeupWordEngineSS2(info, data);
    }
    
    func finishRecording() {
        //ReleaseWakeupWordEngineSS2()
    }
    
    func onBuffer(buffer: AVAudioPCMBuffer, voiceAssistantState: VoiceAssistantState) {
        // GET AUDIO BUFFER
        let int16ptr = buffer
            .mutableAudioBufferList
            .pointee.mBuffers.mData?
            .bindMemory(to: Int16.self, capacity: Int(buffer.frameLength) * MemoryLayout<Int16>.stride)
        
        switch voiceAssistantState {
        case .waiting, .listening:
            if let socket = self.socket {
                if isConnected {
                    socket.write(data: toData(buffer: buffer))
                }
            } else {
                startWebsocket()
            }
        case .active:
            //AcceptWaveFormSS2(int16ptr, 3200) ||
            if(  DataFlowManager.shared.stateOfViViVelocity == .continuous) {
                //wakeup successfully
                // need move to bankassistant
                DispatchQueue.main.async {
                    DataFlowManager.shared.openBankAssistant(navigation: DataFlowManager.shared.exViewController) {}
                }
                AudioPlayer.shared.playSoundEffectWakeup()
                self.startWakeup()
            }
            
        default:
            break
        }
    }
    
    func stopSocket() {
        self.socket?.write(string: "{\"eof\": 1}") {
            // Log.debug(message: "socket.write(string)")
        }
        socket?.disconnect()
    }
}

enum AssistantEvent {
    case receiveTranscript(message: String, isFinal: Bool)
    case stateChanged(state: VoiceAssistantState)
    case stateSocket
    case onWakeup
}

protocol RecorderProtocol {
    func startRecording()
    func stopRecording()
    func manualWakeup()
    func resetAssistant()
    func startSpeak()
    
    var voiceAssistantState: VoiceAssistantState { get set }
    var event: PublishSubject<AssistantEvent> { get set }
    var averagePower: Float { get set }
}

extension RecorderManager: RecorderProtocol {
    // MARK:- Recording
    func startRecording() {
        guard !isRecording() else { return }
        DataFlowManager.shared.changeStateAssistant(state: .activeStateAssistant)
        socketManger.startRecording()
        
        self.recordingTs = NSDate().timeIntervalSince1970
        self.silenceTs = 0
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            
        } catch let error as NSError {
            Log.debug(message: error.localizedDescription)
            return
        }
        
        let inputNode = self.audioEngine.inputNode
        let BUFFER_SIZE: UInt32 = UInt32(44100 * 0.2)
        
        let input = audioEngine.inputNode
        let bus = 0
        let inputFormat = input.outputFormat(forBus: bus)
        
        guard let outputFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 16000, channels: 1, interleaved: true),
              let converter = AVAudioConverter(from: inputFormat, to: outputFormat) else {
            return
        }
        
        inputNode.installTap(onBus: 0, bufferSize: BUFFER_SIZE, format: inputFormat) { [weak self] (buffer, time) in
            guard let `self` = self else { return }
            var newBufferAvailable = true
            
            let inputCallback: AVAudioConverterInputBlock = { inNumPackets, outStatus in
                if newBufferAvailable {
                    outStatus.pointee = .haveData
                    newBufferAvailable = false
                    return buffer
                } else {
                    outStatus.pointee = .noDataNow
                    return nil
                }
            }
            
            
            if let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat,
                                                      frameCapacity: AVAudioFrameCount(outputFormat.sampleRate) * buffer.frameLength / AVAudioFrameCount(buffer.format.sampleRate)) {
                var error: NSError?
                let status = converter.convert(to: convertedBuffer, error: &error, withInputFrom: inputCallback)
                assert(status != .error)
                Log.debug(message: "RUNNING", mode: .stg)
                // 16kHz buffers
                switch self.voiceAssistantState {
                case .active, .listening, .waiting:
                    self.socketManger.onBuffer(buffer: convertedBuffer,
                                               voiceAssistantState: self.voiceAssistantState)
                    //self.audioMetering(buffer: buffer)
                default:
                    break
                }
            }
        }
        do {
            self.audioEngine.prepare()
            try self.audioEngine.start()
        } catch let error as NSError {
            Log.debug(message: error.localizedDescription)
            return
        }
    }
    
    func stopRecording() {
        synchronized(myLock) {
            Log.debug(message: "Stopped")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.audioEngine.stop()
            do {
                try AVAudioSession.sharedInstance().setActive(false)
            } catch  let error as NSError {
                Log.debug(message: error.localizedDescription)
                return
            }
            self.socketManger.finishRecording()
        }
    }
    
    func manualWakeup() {
        socketManger.startWakeup()
    }
    
    func resetAssistant() {
        voiceAssistantState = .active
    }
    
    func startSpeak() {
        voiceAssistantState = .speaking
    }
    
    var averagePower: Float {
        get {
            return averagePowerForChannel1
        }
        set { }
    }
}

class RecorderManager: NSObject {
    private let settings = [
        AVFormatIDKey: kAudioFormatLinearPCM,
        AVLinearPCMBitDepthKey: 16,
        AVLinearPCMIsFloatKey: true,
        AVSampleRateKey: Float64(44100),
        AVNumberOfChannelsKey: 1
    ] as [String : Any]
    
    private let audioEngine = AVAudioEngine()
    private var renderTs: Double = 0
    private var recordingTs: Double = 0
    private var silenceTs: Double = 0
    
    internal var voiceAssistantState: VoiceAssistantState = .active {
        didSet {
            switch voiceAssistantState {
            case .active:
                socketManger.stopSocket()
                AudioPlayer.shared.remove()
            case .waiting:
                startCheckingTimeout()
                AudioPlayer.shared.remove()
            case .listening:
                timoutJob = nil
            case .speaking:
                timoutJob = nil
                socketManger.stopSocket()
            }
            event.onNext(.stateChanged(state: voiceAssistantState))
        }
    }
    
    private let myLock = NSObject();
    
    var event = PublishSubject<AssistantEvent>()
    var assistantState: VoiceAssistantState {
        return .active
    }
    
    private var timoutJob: DispatchWorkItem? {
        didSet {
            oldValue?.cancel()
            guard let job = timoutJob else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: job)
        }
    }
    
    
    private lazy var socketManger: SocketProtocol = SocketManager({
        [weak self] event in
        guard let `self` = self else { return }
        switch event {
        case .onWakeup:
            self.voiceAssistantState = .waiting
        case .receiveTranscript( _, let isFinal):
            self.voiceAssistantState = isFinal ? .speaking :.listening
        default:
            break
        }
        self.event.onNext(event)
    })
    
    private func synchronized<T>(_ lock: AnyObject, _ body: () throws -> T) rethrows -> T {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        return try body()
    }
    
    private func isRecording() -> Bool {
        if self.audioEngine.isRunning {
            return true
        }
        return false
    }
    
    private func format() -> AVAudioFormat? {
        let format = AVAudioFormat(settings: self.settings)
        return format
    }
    
    // MARK:- Paths and files
    private func createAudioRecordPath() -> URL? {
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss-SSS"
        let currentFileName = "recording-\(format.string(from: Date()))" + ".wav"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsDirectory.appendingPathComponent(currentFileName)
        return url
    }
    
    private func createAudioRecordFile() -> AVAudioFile? {
        guard let path = self.createAudioRecordPath() else {
            return nil
        }
        do {
            let file = try AVAudioFile(forWriting: path, settings: self.settings, commonFormat: .pcmFormatFloat32, interleaved: true)
            return file
        } catch let error as NSError {
            Log.debug(message: error.localizedDescription)
            return nil
        }
    }
    
    // MARK:- Handle interruption
    @objc
    private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let key = userInfo[AVAudioSessionInterruptionTypeKey] as? NSNumber
        else { return }
        if key.intValue == 1 {
            DispatchQueue.main.async {
                if self.isRecording() {
                    self.stopRecording()
                }
            }
        }
    }
    
    private func startCheckingTimeout() {
        timoutJob = DispatchWorkItem(block: { [weak self] in
            guard let `self` = self else { return }
            self.resetAssistant()
        })
    }
    
    private var averagePowerForChannel0: Float = 0
    private var averagePowerForChannel1: Float = 0
    let LEVEL_LOWPASS_TRIG:Float32 = 0.30
    
    private func audioMetering(buffer:AVAudioPCMBuffer) {
        buffer.frameLength = 1024
        let inNumberFrames:UInt = UInt(buffer.frameLength)
        if buffer.format.channelCount > 0 {
            let samples = (buffer.floatChannelData![0])
            var avgValue:Float32 = 0
            vDSP_maxmgv(samples,1 , &avgValue, inNumberFrames)
            var v:Float = -100
            if avgValue != 0 {
                v = 20.0 * log10f(avgValue)
            }
            self.averagePowerForChannel0 = (self.LEVEL_LOWPASS_TRIG*v) + ((1-self.LEVEL_LOWPASS_TRIG)*self.averagePowerForChannel0)
            self.averagePowerForChannel1 = self.averagePowerForChannel0
        }
        
        if buffer.format.channelCount > 1 {
            let samples = buffer.floatChannelData![1]
            var avgValue:Float32 = 0
            vDSP_maxmgv(samples, 1, &avgValue, inNumberFrames)
            var v:Float = -100
            if avgValue != 0 {
                v = 20.0 * log10f(avgValue)
            }
            self.averagePowerForChannel1 = (self.LEVEL_LOWPASS_TRIG*v) + ((1-self.LEVEL_LOWPASS_TRIG)*self.averagePowerForChannel1)
        }
    }
    
}
