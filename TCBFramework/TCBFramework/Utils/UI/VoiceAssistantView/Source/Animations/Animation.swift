//
//  Animation.swift
//  Anim
//
//  Created by Anonymos on 25/06/2022.
//

import UIKit

protocol Animation {
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor, repeatCount: Float)
}

struct AnimationConfig {
    static var repeatCount: Float = 0
}


