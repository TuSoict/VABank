//
//  ForgotPasswordCell.swift
//  BankAssistant
//
//  Created by SuperT on 17/07/2022.
//

import UIKit
import SwifterSwift
import YouTubePlayer

class ForgotPasswordCell: BaseTableViewCell {

    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var callButton: UIButton!
    
    override func setupUI() {
        playView.roundCorners([.topRight], radius: 40)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playVideo))
        playView.isUserInteractionEnabled = true
        playView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func playVideo() {
        guard let url = URL(string: "https://www.youtube.com/watch?v=ro3VYLHHsmg") else { return }
        let vc = UIViewController()
        vc.view.frame = UIScreen.main.bounds
        let videoPlayer = YouTubePlayerView()
        vc.view.addSubview(videoPlayer)
        videoPlayer.fillIn(vc.view)
        
        videoPlayer.loadVideoURL(url)
        // tutm comment
       // AppDelegate.shared()?.rootVC?.present(vc, animated: true)
    }
    
    @IBAction func callAction(_ sender: Any) {
        guard let phone = callButton.titleLabel?.text,
                let phoneCallURL = URL(string: "telprompt://\(phone)") else { return }
        UIApplication.shared.open(phoneCallURL)
    }
}
