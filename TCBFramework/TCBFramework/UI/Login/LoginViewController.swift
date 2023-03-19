//
//  LoginViewController.swift
//  BankAssistant
//
//  Created by nguyen.tuan.hai on 14/07/2022.
//

import UIKit
import AVFoundation
import RxSwift

class LoginViewController: BaseViewController {
    @IBOutlet var voiceAssistantView: VoiceAssistantView!
    
    var audioEngineRecorder: AudioEngineRecorder?
    
    let viewModel = LoginViewModel()
    let audioUrls: [URL]
    let nibString : String = "LoginViewController"
    
    public init(audioUrls: [URL] = []) {
        self.audioUrls = audioUrls
        super.init(nibName:nibString, bundle: Bundle(for: LoginViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        viewModel.registerDevice()
        
        Assistant.shared.reset()
        voiceAssistantView.onTouch = {
            Assistant.shared.wakeup()
        }
        
        if !audioUrls.isEmpty {
            Assistant.shared.startSpeak()
            AudioPlayer.shared.playAudio(urls: audioUrls) {
                Assistant.shared.reset()
            }
        }
    }
    
    override func setupEvent() {
        Assistant.shared.event
            .subscribe(onNext: { [weak self] event in
                self?.handleEvent(event)
            }).disposed(by: disposeBag)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let vc = BankAssistantViewController()
        push(vc: vc)
    }
    
}

extension LoginViewController {
    private func handleEvent(_ event: AssistantEvent) {
        switch event {
        case .onWakeup:
            if isViewVisible {
                push(vc: BankAssistantViewController())
            }
        case .stateChanged(let state):
            voiceAssistantView.startAnimation(state: state)
        default:
            break
        }
    }
}
