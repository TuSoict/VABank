//
//  ViewWithXib.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation

import UIKit

class ViewWithXib: UIView {
    var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        contentView = view
        
        setupView()
    }
    
    func setupView() {
        
    }
}

extension UIView {
    func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)),
                        bundle: bundle)
        guard let view = nib.instantiate(withOwner: self,
                                         options: nil)[0] as? UIView else {
            return UIView()
        }
        return view
    }
}
