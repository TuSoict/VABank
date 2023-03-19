//
//  MoneyTransferCell.swift
//  BankAssistant
//
//  Created by SuperT on 19/07/2022.
//

import UIKit

class MoneyTransferCell: BaseTableViewCell {
    
    @IBOutlet weak var avatarByNameImage: UIImageView!
    @IBOutlet weak var userNameToLabel: UILabel!
    @IBOutlet weak var bankNameToLabel: UILabel!
    @IBOutlet weak var transferPriceLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var userNameToInStackLabel: UILabel!
    @IBOutlet weak var accountNumberToInStackLabel: UILabel!
    @IBOutlet weak var bankStatusTransferLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func heightForRow() -> Double {
        return UIScreen.main.bounds.height
    }
    
    override func set(_ data: Any) {
        let payConfirmDict = data as! [String:String]
        self.userNameToLabel.text =  payConfirmDict["user_name_to"].stringValue()
        let payMoneyInt = (payConfirmDict["money"].stringValue() as NSString).integerValue
        self.transferPriceLabel.text =  "VND \(String(format: "%d", locale: Locale.current, payMoneyInt))"
        
        self.userNameLabel.text = payConfirmDict["user_name"].stringValue()
        self.accountNumberLabel.text = payConfirmDict["account_number"].stringValue()
        self.userNameToInStackLabel.text = payConfirmDict["user_name_to"].stringValue()
        self.accountNumberToInStackLabel.text = payConfirmDict["account_number_to"].stringValue()
        
        if payMoneyInt > 500000000 {
            self.bankStatusTransferLabel.text = messageString.sameDay.rawValue
        } else {
            self.bankStatusTransferLabel.text = messageString.payNow.rawValue
        }
        
        self.avatarByNameImage.layer.cornerRadius
        = self.avatarByNameImage.frame.height / 2;
        self.avatarByNameImage.layer.shouldRasterize = true
        self.avatarByNameImage.clipsToBounds = true
        self.avatarByNameImage.backgroundColor = .brown
    }
}
