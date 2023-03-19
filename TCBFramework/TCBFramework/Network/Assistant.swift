//
//  Assistant.swift
//  BankAssistant
//
//  Created by SuperT on 16/07/2022.
//

import Foundation
import RxSwift
import AVFoundation
import RxCocoa

public class Assistant {
    
    static let shared = Assistant()

    private var disposeBag = DisposeBag()
    private lazy var recorder: RecorderProtocol = RecorderManager()
    
    var event: Observable<AssistantEvent> {
        return recorder.event
            .observe(on: MainScheduler.asyncInstance)
            .asObservable()
    }
    
    var state: VoiceAssistantState {
        return recorder.voiceAssistantState
    }
    
    var averagePower: Float {
        return recorder.averagePower
    }
}

extension Assistant {
    public func start() {
        let permission = AVAudioSession.sharedInstance().recordPermission
        switch permission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (result) in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: AIBankNotification.requestRecordPermission.name, object: nil)
                    if result {
                        self.recorder.startRecording()
                        Log.debug(message: "recording")
                    }
                    else {
                        Log.debug(message: "denined")
                    }
                }
            })
            break
        case .granted:
            DispatchQueue.main.async {
                self.recorder.startRecording()
            }
            Log.debug(message: "recording")
            break
        case .denied:
            Log.debug(message: "denined")
            break
        @unknown default:
            Log.debug(message: "error")
        }
    }

    public func stop() {
        recorder.stopRecording()
    }
    
    public func wakeup() {
        recorder.manualWakeup()
    }
    
    public func reset() {
        recorder.resetAssistant()
    }
    
    public func startSpeak() {
        recorder.startSpeak()
    }
}
