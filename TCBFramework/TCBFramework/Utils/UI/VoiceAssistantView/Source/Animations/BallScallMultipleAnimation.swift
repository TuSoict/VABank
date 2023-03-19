//
//  BallScallMultipleAnimation.swift
//  Anim
//
//  Created by SuperT on 26/06/2022.
//

import UIKit

final class BallScallMultipleAnimation: Animation {
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor, repeatCount: Float) {
        guard repeatCount >= 0 else { return }
        
        let duration: CFTimeInterval = 1.8
        let beginTime = CACurrentMediaTime()
        let beginTimes = [0, 0.3, 0.6]
        
        // Scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        scaleAnimation.duration = duration
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 2
        
        // Opacity animation
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        
        opacityAnimation.duration = duration
        opacityAnimation.keyTimes = [0, 0.05, 1]
        opacityAnimation.values = [0, 1, 0]
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimation]
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = false
        
        // Draw balls
        for i in 0 ..< 3 {
            let circle = ShapeLayer.circle.layer(size: size, color: color)
            let frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
                               y: (layer.bounds.size.height - size.height) / 2,
                               width: size.width,
                               height: size.height)
            
            animation.beginTime = beginTime + beginTimes[i]
            circle.frame = frame
            circle.opacity = 0
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }
}
