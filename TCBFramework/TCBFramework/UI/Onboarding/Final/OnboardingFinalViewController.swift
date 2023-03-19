//
//  OnboardingFinalViewController.swift
//  BankAssistant
//
//  Created by nguyen.tuan.hai on 20/07/2022.
//

import UIKit
import AVFAudio

class OnboardingFinalViewController: UIViewController {

    @IBOutlet weak var voiceAssistantView: VoiceAssistantView!
    
    private var audioPlayerOnboarding: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        playOnboarding()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction private func loginButtonTapped(_ sender: UIButton) {
        // tutmt commet
        //AppDelegate.shared()?.setRootNavi(with: LoginViewController())
    }
    
    private func playOnboarding() {
        if let url = Resouces.getMP3File(mp3BundleFile: .onboarding4) {
            do {
                Log.debug(message: "========= start play")
                audioPlayerOnboarding = try AVAudioPlayer(contentsOf: url)
                audioPlayerOnboarding.prepareToPlay()
                audioPlayerOnboarding.play()
                audioPlayerOnboarding.delegate = self
                voiceAssistantView.startAnimation(state: .speaking)
            } catch let error as NSError {
                Log.debug(message: "========= " + error.localizedDescription)
            } catch {
            }
        }
    }
}

extension OnboardingFinalViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayerOnboarding = nil
        voiceAssistantView.startAnimation(state: .active)
    }
}
