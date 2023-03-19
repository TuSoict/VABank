//
//  UIView+Extension.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius     }
    }
}

extension UIView {
    func set(height: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func set(width: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func fillIn(_ view: UIView, padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding.bottom),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding.right)
        ])
    }
    
    func centerInView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
    
    func removeArrangedSubviews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
        }
    }
}
