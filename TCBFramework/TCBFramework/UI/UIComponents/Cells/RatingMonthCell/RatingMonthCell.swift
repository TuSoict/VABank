//
//  RatingMonthCell.swift
//  BankAssistant
//
//  Created by Anonymous on 20/07/2022.
//

import UIKit

class RatingMonthCell: BaseTableViewCell {
    @IBOutlet weak var period1Label: UILabel!
    @IBOutlet weak var period2Label: UILabel!
    
    @IBOutlet weak var vndView: UIView!
    @IBOutlet weak var usdView: UIView!
    
    override func set(_ data: Any) {
        guard let rating = data as? Rating else { return }
        
        if let vnd = rating.vnd {
            period1Label.text = "Kỳ hạn \(vnd) tháng"
            vndView.isHidden = false
        } else {
            vndView.isHidden = true
        }
        
        if let usd = rating.usd {
            period2Label.text = "Kỳ hạn \(usd) tháng"
            usdView.isHidden = false
        } else {
            usdView.isHidden = true
        }
        
    }
}
