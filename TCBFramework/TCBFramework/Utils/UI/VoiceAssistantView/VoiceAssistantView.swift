//
//  VoiceAssistantView.swift
//  LocalFramworkWithPod
//
//  Created by SuperT on 26/06/2022.
//

import UIKit
import Lottie

enum VoiceAssistantState: String {
    case active
    case waiting
    case listening
    case speaking
}

final class VoiceAssistantView: UIView {

    var onTouch: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
//        avatarImagView.image = UIImage.by(name: "ic_voice")
//        addSubview(avatarImagView)
//        avatarImagView.translatesAutoresizingMaskIntoConstraints = false
//        avatarImagView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        avatarImagView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        avatarImagView.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        avatarImagView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private var currentState: VoiceAssistantState? {
        didSet {
            guard oldValue != currentState else { return }
        
            for view in subviews.filter({ $0.isKind(of: AnimationView.self)}) {
                view.removeFromSuperview()
                (view as! AnimationView).stopAnimating()
            }
            
            let animationView = AnimationView()
            animationView.startAnimating()
            
            switch currentState {
            case .active:
                animationView.repeatCount = -1
                animationView.type = .ballScaleMultiple
                animationView.color = DataFlowManager.viviColor()
                animationView.avatarImage = UIImage.getImage(imagesBundleFile: .icVoice)
            case .waiting, .listening:
                animationView.type = .ballPulse
                animationView.padding = 15
                animationView.color = .white
                animationView.backgroundImage = UIImage.getImage(imagesBundleFile: .icCircle)
            case .speaking:
                animationView.type = .ballScaleMultiple
                animationView.color = DataFlowManager.viviColor()
                animationView.avatarImage = UIImage.getImage(imagesBundleFile: .icVoice)
            default:
                return
            }
            animationView.bounds = bounds
            animationView.frame.origin = .zero
            
            addSubview(animationView)
        }
    }
    
    func startAnimation(state: VoiceAssistantState) {
        DispatchQueue.main.async {
            self.currentState = state
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        onTouch?()
    }
}

