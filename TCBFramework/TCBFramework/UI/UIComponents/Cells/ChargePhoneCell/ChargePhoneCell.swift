//
//  ChargePhoneCell.swift
//  BankAssistant
//
//  Created by SuperT on 20/07/2022.
//

import UIKit

class ChargePhoneCell: BaseTableViewCell {

    @IBOutlet weak var phoneLabel: UILabel!
    
    override func set(_ data: Any) {
        guard let phone = data as? String else { return }
        self.phoneLabel.text = phone
    }
    
}
