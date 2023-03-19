//
//  VAWaitingViewController.swift
//  BankAssistant
//
//  Created by nguyen.tuan.hai on 15/07/2022.
//

import UIKit

class VAWaitingViewController: BaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var voiceAssistantView: VoiceAssistantView!
    @IBOutlet weak var textToSpeakLabel: UILabel!
    
    let viewModel = VAWaitingViewModel()

}
