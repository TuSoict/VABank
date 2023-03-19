//
//  BankTransferConfirmCell.swift
//  BankAssistant
//
//  Created by SuperT on 19/07/2022.
//

import UIKit

class BankTransferConfirmCell: BaseTableViewCell {

    @IBOutlet weak var moneyTf: UITextField!
    
    override func set(_ data: Any) {
        guard let money = data as? String else { return }
        moneyTf.text = money
    }
}
