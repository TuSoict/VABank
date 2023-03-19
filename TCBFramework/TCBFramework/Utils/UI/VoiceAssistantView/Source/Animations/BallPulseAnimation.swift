//
//  BallPulseAnimation.swift.swift
//  Anim
//
//  Created by Anonymos on 25/06/2022.
//

import UIKit

final class BallPulseAnimation: Animation {
    
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor, repeatCount: Float) {
        let circleSpacing: CGFloat = 5
        let circleSize = (size.width - circleSpacing * 2) / 3
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - circleSize) / 2
        let deltaY = (size.height / 2 - circleSize / 2) / 2
        let duration: CFTimeInterval = 0.6
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.07, 0.14, 0.21]
        let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Animation
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        
        animation.keyTimes = [0, 0.33, 0.66, 1]
        animation.timingFunctions = [timingFunction, timingFunction, timingFunction]
        animation.values = [0, deltaY, -deltaY, 0]
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = false
        
        // Draw circles
        for i in 0 ..< 3 {
            let circle = ShapeLayer.circle.layer(size: CGSize(width: circleSize, height: circleSize), color: color)
            let frame = CGRect(x: x + circleSize * CGFloat(i) + circleSpacing * CGFloat(i),
                               y: y,
                               width: circleSize,
                               height: circleSize)
            
            animation.beginTime = beginTime + beginTimes[i]
            circle.frame = frame
            if repeatCount > 0 {
                circle.add(animation, forKey: "animation")
            }
            layer.addSublayer(circle)
        }
    }
}
