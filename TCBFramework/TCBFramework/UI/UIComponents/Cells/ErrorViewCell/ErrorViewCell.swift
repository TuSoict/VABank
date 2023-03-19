//
//  ErrorViewCell.swift
//  TCB-Framework
//
//  Created by Ly Nghia on 3/15/23.
//

import UIKit

class ErrorViewCell: BaseTableViewCell {

    var onBackVAHome: (() -> Void)?
    
    @IBAction func retryButtounTouchUpInside(_ sender: Any) {
        self.onBackVAHome?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func heightForRow() -> Double {
        return UIScreen.main.bounds.height
    }
    
    override func set(_ data: Any) {
        
    }
    
    
}
