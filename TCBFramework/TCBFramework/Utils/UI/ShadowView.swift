//
//  ShadowView.swift
//  BankAssistant
//
//  Created by Anonymous on 18/07/2022.
//

import UIKit

final class ShadowView: UIView {

    @IBInspectable
    var isStandard: Bool = true
    
    var corners: UIRectCorner? = .allCorners
    var offset: CGPoint = .zero
    
    public func setupShadow() {
        if isStandard {
            self.backgroundColor = .white
            self.shadowRadius = 10
            self.shadowColor = .black
            self.shadowOpacity = 0.2
            self.offset = CGPoint(x: -10, y: 0)
        }
        if let corners = corners {
            layer.shadowOffset = CGSize(width: 0, height: 1)
            layer.shadowRadius = shadowRadius
            layer.shadowOpacity = shadowOpacity
            layer.shadowColor = shadowColor?.cgColor ?? UIColor.black.cgColor
            if corners == .allCorners {
                layer.cornerRadius = shadowRadius
            } else {
                roundingCorners(radius: shadowRadius, corners: corners)
            }
            layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: -offset.x, y: -offset.y,
                                                                width: bounds.width + offset.x,
                                                                height: bounds.height + offset.y),
                                            byRoundingCorners: corners,
                                            cornerRadii: CGSize(width: 2, height: 2)).cgPath
        } else {
            layer.shadowPath = nil
            layer.cornerRadius = 0
            layer.shadowColor = UIColor.clear.cgColor
        }
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
    }
}

private extension UIView {
    func roundingCorners(radius: CGFloat, corners: UIRectCorner, color: UIColor? = .white) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        backgroundColor = color
    }
}
