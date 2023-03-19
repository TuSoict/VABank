//
//  BankAssistantViewModel.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class BankAssistantViewModel: BaseViewModel {
    
    let message = BehaviorRelay<BotMessage?>(value: nil)
    var isNeedCancelCurrentThread:Bool? = false
    
    override func setupData() {
        Assistant.shared.start()
    }
    
    private func didReceiveMessage(_ messages: [BotMessage]) {
        
        let textMessages = messages.filter({ $0.type == .text })
        
        if textMessages.count > 1 {
            message.accept(textMessages.first)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.didReceiveMessage(messages.filter({ $0.command != textMessages.first?.command }))
            }
            return
        }
        
        let voiceMessage = messages.first(where: {$0.type == .voice})
        let textMessage = messages.first(where: {$0.type == .text})
        
        if let message = voiceMessage {
            generateAudio(from: message)
        } else {
            if textMessage?.isNextListening == true {
                Assistant.shared.wakeup()
            } else {
                Assistant.shared.reset()
            }
        }
        
        message.accept(textMessage)
        
    }
}

extension BankAssistantViewModel {
    func sendVoice(_ message: String) {
        Log.debug(message: "send \(message)")
        AssistantService.shared.pushMessage(message)
            .delay(.microseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                Log.debug(message: "\(response.jsonString)", mode: .debug)
                self.didReceiveMessage(response.botMessages ?? [])
            }, onFailure: { error in
                Log.debug(message: "\(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func generateAudio(from botMessage: BotMessage) {
        guard let text = botMessage.value else { return }
        AssistantClient.generateAudio(text: text,
                                      languageCode: "vi_vn",
                                      voiceName: "female_south2",
                                      generator: "melgan",
                                      acousticModel: "fastspeech2",
                                      style: "news",
                                      ouputFormat: "mp3")
        .subscribe(onSuccess: getAudio)
        .disposed(by: disposeBag)
        
    }
    
    private func getAudio(from response: AudioResponse) {
        guard let data = response.responseData else {
            return
        }
        class AudioData {
            var id: Int
            var audioId: String
            var url: String = ""
            
            init(id: Int, audioId: String) {
                self.id = id
                self.audioId = audioId
            }
        }
        
        var datas: [AudioData] = []
        data.sentences?.forEach({ sentence in
            datas.append(AudioData(id: datas.count + 1, audioId: sentence))
        })
        
        let group = DispatchGroup()
        
        datas.forEach({ data in
            group.enter()
            getAudioByID(data.audioId) { url in
                data.url = url.stringValue()
                group.leave()
            }
        })
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            let url = datas.map({ URL(string: $0.url) }).filter({ $0 != nil }) as! [URL]
            self?.playAudio(url)
        }
    }
    
    private func playAudio(_ urls: [URL]) {
        if message.value?.command == .login {
            let loginVC = LoginViewController(audioUrls: urls)
            //tutm cmt
            //AppDelegate.shared()?.setRoot(UINavigationController(rootViewController: loginVC ))
            return
        }
        
        Assistant.shared.startSpeak()
        AudioPlayer.shared.playAudio(urls: urls) { [weak self] in
            guard let `self` = self else { return }
            if self.message.value?.isNextListening == true {
                Assistant.shared.wakeup()
            } else {
                Assistant.shared.reset()
            }
        }
    }
    
    private func getAudioByID(_ id: String, completionHanlder: @escaping (String?) -> Void) {
        AssistantClient.getAudio(id)
            .subscribe(onSuccess: { audioLink in
                completionHanlder(audioLink)
            }, onFailure: { error in
                completionHanlder(nil)
            })
            .disposed(by: disposeBag)
    }
}
