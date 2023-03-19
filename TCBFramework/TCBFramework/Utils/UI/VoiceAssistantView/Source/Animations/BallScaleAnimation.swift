//
//  BallScaleAnimation.swift
//  Anim
//
//  Created by Anonymos on 25/06/2022.
//

import UIKit

final class BallScaleAnimation: Animation {
    let duration: CFTimeInterval = 1.8
    let scaleRatio: CGFloat = 1.1
    let ratio: CGFloat = 1
    
    var repeatCount: Float = HUGE
    
    var coreSize: CGFloat = 0
    
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor, repeatCount: Float) {
        self.repeatCount = repeatCount
        
        coreSize = size.width * ratio

        ring1InLayer(layer, size: size, color: color)
        //ring2InLayer(layer, size: size, color: color)
        coreInLayer(layer, size: size, color: color)
    }
    
    func ring1InLayer(_ layer: CALayer, size _: CGSize, color: UIColor) {
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.45, 0.45, 1]
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        scaleAnimation.values = [0, 0, 1.3, 2]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
        
        opacityAnimation.keyTimes = [0, 0.45, 1]
        scaleAnimation.timingFunctions = [CAMediaTimingFunction(name: .linear), timingFunction]
        opacityAnimation.values = [0.8, 0.8, 0]
        opacityAnimation.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimation]
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = false
        
        // Draw circle
        let circle = ShapeLayer.circle.layer(size: CGSize(width: coreSize, height: coreSize), color: color)
        let frame = CGRect(x: (layer.bounds.size.width - coreSize) / 2,
                           y: (layer.bounds.size.height - coreSize) / 2,
                           width: coreSize,
                           height: coreSize)
        
        circle.frame = frame
        circle.add(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
    
    func ring2InLayer(_ layer: CALayer, size _: CGSize, color: UIColor) {
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.55, 0.55, 1]
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        scaleAnimation.values = [0, 0, 1.3, 2.1]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
        
        opacityAnimation.keyTimes = [0, 0.55, 0.65, 1]
        scaleAnimation.timingFunctions = [CAMediaTimingFunction(name: .linear), timingFunction]
        opacityAnimation.values = [0.7, 0.7, 0, 0]
        opacityAnimation.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimation]
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = false
        
        // Draw circle
        let circle = ShapeLayer.circle.layer(size: CGSize(width: coreSize, height: coreSize), color: color)
        let frame = CGRect(x: (layer.bounds.size.width - coreSize) / 2,
                           y: (layer.bounds.size.height - coreSize) / 2,
                           width: coreSize,
                           height: coreSize)
        
        circle.frame = frame
        circle.add(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
    
    func coreInLayer(_ layer: CALayer, size _: CGSize, color: UIColor) {
        let inTimingFunction = CAMediaTimingFunction(controlPoints: 0.7, 0, 1, 0.5)
        let outTimingFunction = CAMediaTimingFunction(controlPoints: 0, 0.7, 0.5, 1)
        let standByTimingFunction = CAMediaTimingFunction(name: .linear)
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.45, 0.55, 1]
        scaleAnimation.timingFunctions = [inTimingFunction, standByTimingFunction, outTimingFunction]
        scaleAnimation.values = [1, 1.3, 1.3, 1]
        scaleAnimation.duration = duration
        scaleAnimation.repeatCount = repeatCount
        scaleAnimation.isRemovedOnCompletion = false
        
        // Draw circle
        let circle = ShapeLayer.circle.layer(size: CGSize(width: coreSize, height: coreSize), color: color)
        let frame = CGRect(x: (layer.bounds.size.width - coreSize) / 2,
                           y: (layer.bounds.size.height - coreSize) / 2,
                           width: coreSize,
                           height: coreSize)
        
        circle.frame = frame
        circle.add(scaleAnimation, forKey: "animation")
        layer.addSublayer(circle)
    }
}
