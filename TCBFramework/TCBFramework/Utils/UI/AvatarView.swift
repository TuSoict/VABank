//
//  AvatarView.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation
import UIKit

class AvatarView: UIView {
    
    let bacgroundImageView = UIImageView().apply {
        $0.backgroundColor = Colors.lightGray
        $0.contentMode = .scaleAspectFill
    }
    
    let iconImageView = UIImageView().apply {
        $0.backgroundColor = Colors.lightGray
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        addSubview(bacgroundImageView)
        addSubview(iconImageView)
        bacgroundImageView.fillIn(self)
        iconImageView.centerInView(self)
    }
    
    func setBackground(_ url: String) {
        iconImageView.image = nil
        bacgroundImageView.image = UIImage.by(name: url)
        //bacgroundImageView.setImage(url)
    }
    
    func setIcon(_ url: String) {
        bacgroundImageView.image = nil
        //iconImageView.setImage(url)
        iconImageView.image = UIImage.by(name: url)
    }
}
