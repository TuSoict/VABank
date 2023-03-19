//
//  ShapeLayer.swift
//  Anim
//
//  Created by Anonymos on 25/06/2022.
//

import UIKit

enum ShapeLayer {
    case circle
    
    func layer(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        
        switch self {
        case .circle:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 0,
                        endAngle: CGFloat(2 * Double.pi),
                        clockwise: false)
            layer.fillColor = color.cgColor
        }
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }
}
