//
//  AudioEngineRecorder.swift
//  VPButlerCore
//
//  Created by Minh Nguyễn on 02/12/2021.
//  Copyright © 2021 Vinpearl JSC. All rights reserved.
//

import AVFoundation

protocol AudioEngineRecorderDelegate: AnyObject {
    func audioEngineDidReceiveData(_ buffer: Data)
    func audioEngineDidReceiveBuffer(_ buffer: AVAudioPCMBuffer)
    func onRecorderError()
}

enum AudioEngineRecoderOutputType {
    case data
    case avAudioPCMBuffer
}

class AudioEngineRecorder {
    weak var delegate: AudioEngineRecorderDelegate?
    public var outputType: AudioEngineRecoderOutputType = .data
    // public var saveOutput: Bool = false
    public var outputFileName: String = "audio.wav"
    
    private var isRunning = false
    private var engine: AVAudioEngine!
    private var mixerNode: AVAudioMixerNode!
    private var fileURL: URL?
    private var avAudioFile: AVAudioFile?
    var voiceAssistantState: VoiceAssistantState = .active
    
    init() {
        self.setupSession()
        self.setupEngine()
    }
    
    private func setupSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord)
        try? session.overrideOutputAudioPort(.speaker)
        try? session.setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    private func setupEngine() {
        self.engine = AVAudioEngine()
        self.mixerNode = AVAudioMixerNode()
        // self.mixerNode.volume = 0
        self.engine.attach(mixerNode)
        let inputNode = self.engine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        self.engine.connect(inputNode, to: mixerNode, format: inputFormat)
        self.engine.prepare() /// Prepare the engine in advance, in order for the system to allocate the necessary resources
    }
    
    private func setupOutput() {
        self.fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.outputFileName)
        self.avAudioFile = AVAudioFile.init16KhzWithURL(url:fileURL!)
    }
    
    /**! Phương thức thực hiện ghi âm */
    func startRecording() throws {
        if self.isRunning {
            return
        } else {
            self.isRunning = true
        }
        // self.setupOutput()
        let tapNode: AVAudioNode = mixerNode /// get output of mixer node
        let format = tapNode.inputFormat(forBus: 0)
        guard let outputFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 16000, channels: 1, interleaved: true),
              let converter = AVAudioConverter(from: format, to: outputFormat)
        else { return
        }
        tapNode.installTap(onBus: 0, bufferSize: 1600, format: format) { (buffer, time) -> Void in /// get the output
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
            if let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: AVAudioFrameCount(outputFormat.sampleRate) * buffer.frameLength / AVAudioFrameCount(buffer.format.sampleRate)) { /// convert to output format
                var error: NSError?
                let status = converter.convert(to: convertedBuffer, error: &error, withInputFrom: inputCallback)
                assert(status != .error)
                switch self.outputType {
                case .avAudioPCMBuffer:
                    self.delegate?.audioEngineDidReceiveBuffer(convertedBuffer)
                    break
                case .data:
                    let data = Data(buffer:convertedBuffer)
                    self.delegate?.audioEngineDidReceiveData(data)
                    break
                }
                
                /*
                if self.saveOutput {
                    try? self.avAudioFile!.write(from: convertedBuffer)
                }*/
            }
        }
        do {
            try engine.start()
        } catch {
            self.delegate?.onRecorderError()
        }
        
    }
    
    /**! Phương thức dừng việc ghi âm */
    func stopRecording() {
        if (!self.isRunning) {
            return
        } else {
            self.isRunning = false
        }
        self.mixerNode.removeTap(onBus: 0)
        self.engine.stop()
        // converter.reset()
    }
}

extension AVAudioFile {
    static func init16KhzWithURL(url:URL) -> AVAudioFile {
        let outputFormatSettings = [
            AVFormatIDKey:kAudioFormatLinearPCM,
            AVLinearPCMBitDepthKey:16,
            AVSampleRateKey: 16000.0,
            AVNumberOfChannelsKey: 1
        ] as [String : Any]
        let audioFile = try! AVAudioFile(forWriting: url, settings: outputFormatSettings, commonFormat: .pcmFormatInt16, interleaved: true)
        return audioFile
    }
}

extension Data {
    static func fromDocumentDirectory(fileName:String) -> Data? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths.first!
        let url = path.appendingPathComponent(fileName)
        let data = try? Data(contentsOf:url)
        return data
    }
    
    static func fromBundle(fileName:String, fileExtension:String) -> Data? {
        let url = Bundle.main.url(forResource: fileName, withExtension:fileExtension)
        let data = try? Data(contentsOf:url!)
        return data
    }
    
    init(buffer: AVAudioPCMBuffer) {
        let audioBuffer = buffer.audioBufferList.pointee.mBuffers
        self.init(bytes: audioBuffer.mData!, count: Int(audioBuffer.mDataByteSize))
    }
    
    func writeToDocumentDirectory(name:String) {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(name)
        do {
            try self.write(to: fileURL, options: .atomic)
        } catch {
            Log.debug(message: error.localizedDescription)
        }
    }
    
    func makePCMBuffer(format: AVAudioFormat) -> AVAudioPCMBuffer? {
        let streamDesc = format.streamDescription.pointee
        let frameCapacity = UInt32(count) / streamDesc.mBytesPerFrame
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCapacity) else { return nil }
        
        buffer.frameLength = buffer.frameCapacity
        let audioBuffer = buffer.audioBufferList.pointee.mBuffers
        
        withUnsafeBytes { (bufferPointer) in
            guard let addr = bufferPointer.baseAddress else { return }
            audioBuffer.mData?.copyMemory(from: addr, byteCount: Int(audioBuffer.mDataByteSize))
        }
        
        return buffer
    }
}
