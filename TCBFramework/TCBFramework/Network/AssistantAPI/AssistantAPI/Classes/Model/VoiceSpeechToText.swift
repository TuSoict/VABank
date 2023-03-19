//
//  VoiceSpeechToText.swift
//  Pods
//
//  Created by Cong Nguyen on 31/05/2022.
//

//import UIKit
//import AVFoundation
//import Starscream
//import Reachability
//
//public protocol VoiceSpeechToTextDelegate: AnyObject {
//    func onReceivedAudioBuffer()
//    func onAsrResponse(partial: String, text: String, spokenText: String, sessionId: String)
//    func onConnectedWebsocket()
//    func onDisconnectedWebsocket(reason: String, code: UInt16)
//    func onConnectWebsocketError()
//}
//
//@objc public class VoiceSpeechToText: NSObject {
//    public weak var delegate: VoiceSpeechToTextDelegate?
//    public var coreDelegate: VoiceSpeechToTextDelegate?
//    public var deviceId: String = ""
//    public var isForwardMessage: Bool = true
//    public var webSocketUrl: String = AppEnvironment.shared.webSocketUrl
//    public var token: String = ""
//    
//    public var isRecording = false
//    
//    private var reachabilityCurrent: Reachability!
//    public var isInternetConnected = false
//    
//    private var socket: WebSocket!
//    private let avEngineRecord = AudioEngineRecorder()
//    private var isConnected = false
//    private var sessionId = ""
//    
//    private var audioPlayer: AVAudioPlayer!
//    private var isPlayWakeup = false
//    
//    public override init() {
//        super.init()
//        self.avEngineRecord.delegate = self
//        self.startNotifierReachability()
//    }
//    
//    
//    /**! Phương thức này thực hiện việc đăng ký nhận thông báo về việc thay đổi trạng thái mạng */
//    private func startNotifierReachability() {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(note:)), name: .reachabilityChanged, object: self.reachabilityCurrent)
//        do {
//            self.reachabilityCurrent = try Reachability()
//            try reachabilityCurrent.startNotifier()
//        } catch {
//            Log.debug(message: "===== Unable to start notifier")
//        }
//    }
//    
//    @objc func reachabilityChanged(note: Notification) {
//        let reachability = note.object as! Reachability
//        
//        switch reachability.connection {
//        case .wifi:
//            self.isInternetConnected = true
//            break
//            
//        case .cellular:
//            self.isInternetConnected = true
//            break
//            
//        case .none:
//            self.isInternetConnected = false
//            break
//            
//        case .unavailable:
//            self.isInternetConnected = false
//            break
//        }
//    }
//    
//    
//    /**! Phương thức này thực hiện việc khởi tạo kết nối với WebSocket */
//    @objc public func initSocket() {
//        var request = URLRequest(url: URL(string: self.webSocketUrl)!)
//        token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2YV9hZ2VudF9pZCI6MTY1MzI5Mjg2ODgxMzE4MjEwOSwiZGV2aWNlX2lkIjoxNjU0MDA3NDc4OTM1ODE0NTM5LCJ0eXBlIjoiYWNjZXNzX3Rva2VuIiwiaWF0IjoxNjU0Njc1MDc0LCJleHAiOjE2NTQ3NjE0NzR9.hSSzDGoAQfw29Y5g9Qg3RSR5xwmrQFDbDaxpAGRHag4"
//        request.setValue(token, forHTTPHeaderField: "token")
//        request.setValue("1654007478935814539", forHTTPHeaderField: "device_id")
//        request.setValue("1654007478935814539_1653928466", forHTTPHeaderField: "session_id")
//        request.setValue("true", forHTTPHeaderField: "forward_message")
//        self.socket = WebSocket(request: request)
//        self.socket.delegate = self
//        self.socket.connect()
//    }
//    
//    /**! Phương thức này thực hiện Bắt đầu ghi âm */
//    @objc public func startRecord() {
//        
//        if self.isInternetConnected {
//            do {
//                try self.avEngineRecord.startRecording()
//                self.sessionId = generateSessionId(deviceId: self.deviceId)
//                
//                self.initSocket()
//                self.isRecording = true
//            } catch {
//                // Log.debug(message: "Lỗi thực hiện ghi âm")
//                self.isRecording = false
//            }
//        } else {
//            // Log.debug(message: "Không có kết nối internet")
//            self.connectWebSocketError()
//        }
//    }
//    
//    
//    /**! Phương thức này thực hiện việc dừng ghi âm */
//    @objc public func stopRecord() {
//        self.avEngineRecord.stopRecording()
//        self.isRecording = false
//        self.isPlayWakeup = false
//        if self.socket != nil && self.isConnected {
//            self.socket.write(string: "EOS") {
//                 Log.debug(message: "socket.write(string)")
//            }
//        }
//    }
//    
//    
//    /**! Phương thức này thực hiện việc chuyển đổi dữ liệu text nhận được từ SST và trả dữ liệu ra ngoài qua phương thức delegate: onAsrResponse */
//    // sau khi thực hiện SST thì sẽ ngắt kết nối với WebSocket bằng cách gửi lên chuỗi "EOS"
//    private func convertAndResponse(responseString: String) {
//        let data = AssistantClient.convertResponseToObject(jsonString: responseString)
//        let sttReceivedModel = SpeechToTextReceived(JSON: data)
//        let spokenText = sttReceivedModel?.spoken_text ?? ""
//        let text = sttReceivedModel?.text ?? ""
//        let partial = sttReceivedModel?.partial ?? ""
//        self.delegate?.onAsrResponse(partial: partial, text: text, spokenText: spokenText, sessionId: self.sessionId)
//        self.coreDelegate?.onAsrResponse(partial: partial, text: text, spokenText: spokenText, sessionId: self.sessionId)
//        
//        self.isPlayWakeup = false
//        
//        // sau khi người dùng nói xong một câu, nhận được dữ liệu spokenText → thực hiện ngắt kết nối với WebSocket
//        if spokenText != "" {
//            Log.debug(message: "socket.response: \(spokenText)")
//            self.socket.write(string: "EOS") {
//                 Log.debug(message: "socket.write(string)")
//            }
//        }
//    }
//    
//    // Thông báo kết nối websocket thành công
//    private func connectedWebSocket() {
//        if !self.isPlayWakeup {
//            self.playWakeupWhenConnectedWebsocket()
//            self.isPlayWakeup = true
//        }
//        
//        self.isConnected = true
//        self.delegate?.onConnectedWebsocket()
//    }
//    
//    // Thông báo ngắt kết nối WebSocket
//    private func disconnectedWebSocket(reason: String, code: UInt16) {
//        self.isConnected = false
//        self.delegate?.onDisconnectedWebsocket(reason: reason, code: code)
//        self.coreDelegate?.onDisconnectedWebsocket(reason: reason, code: code)
//        self.stopRecord()
//    }
//    
//    // Thông báo khi không có kết nối internet
//    private func connectWebSocketError() {
//        self.isConnected = false
//        self.delegate?.onConnectWebsocketError()
//    }
//    
//    
//    // thực hiện mở file ting_wakeup để thông báo đã kết nối với WebSocket
//    private func playWakeupWhenConnectedWebsocket() {
//        let filePathVoice = Bundle(identifier: "com.vin.assistanttest")!.path(forResource: "ting_wakeup", ofType: "wav")
//        let urlFileVoice = URL(fileURLWithPath: filePathVoice!)
//        do {
//            self.audioPlayer = try AVAudioPlayer(contentsOf: urlFileVoice)
//            self.audioPlayer.delegate = self
//            self.audioPlayer.prepareToPlay()
//            self.audioPlayer.play()
//        } catch {
//            print ("There is an issue with this code!")
//        }
//    }
//}
//
//extension VoiceSpeechToText: AVAudioPlayerDelegate {
//    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        self.audioPlayer.stop()
//    }
//}
//
//
//
//extension VoiceSpeechToText: AudioEngineRecorderDelegate {
//    func onRecorderError() {
//        // Nếu lỗi mic thì làm gì
//        Log.debug(message: "onRecorderError")
//    }
//    
//    func audioEngineDidReceiveData(_ buffer: Data) {
//        self.coreDelegate?.onReceivedAudioBuffer()
//        if !self.isConnected && self.socket == nil && self.isRecording {
//            self.initSocket()
//        } else {
//            socket.write(data: buffer)
//        }
//    }
//    
//    func audioEngineDidReceiveBuffer(_ buffer: AVAudioPCMBuffer) {
//         Log.debug(message: "buffer AVAudioPCMBuffer = \(buffer)")
//    }
//    
//    func generateSessionId(deviceId: String) -> String {
//        let timestamp = NSDate().timeIntervalSince1970
//        let timestampMinisecond: Int = Int(timestamp * 1000)
//        let sessionId = deviceId + "_" + "\(timestampMinisecond)"
//        return sessionId
//    }
//
//}
//
//
//extension VoiceSpeechToText: WebSocketDelegate {
//    
//    public func didReceive(event: WebSocketEvent, client: WebSocket) {
//        switch event {
//        case .connected(let headers):
//            self.connectedWebSocket()
//            Log.debug(message: "websocket is connected: \(headers)")
//            break
//            
//        case .disconnected(let reason, let code):
//            self.disconnectedWebSocket(reason: reason, code: code)
//            Log.debug(message: "websocket is disconnected: \(reason) with code: \(code)")
//            self.socket = nil
//            break
//            
//        case .text(let string):
//            self.convertAndResponse(responseString: string)
//            break
//            
//        case .binary(let data):
//            Log.debug(message: "Received data: \(data.count)")
//            break
//            
//        case .ping(_):
//            break
//            
//        case .pong(_):
//            break
//            
//        case .viabilityChanged(_):
//            break
//            
//        case .reconnectSuggested(_):
//            break
//            
//        case .cancelled:
//            self.isConnected = false
//            break
//            
//        case .error(let error):
//            self.connectWebSocketError()
//            Log.debug(message: "error= \(String(describing: error))")
//        }
//    }
//}
//
