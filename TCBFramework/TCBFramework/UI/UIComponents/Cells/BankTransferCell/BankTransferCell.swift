//
//  BankTransferCell.swift
//  BankAssistant
//
//  Created by SuperT on 19/07/2022.
//

import UIKit

class BankTransferCell: BaseTableViewCell {

    @IBOutlet weak var accountTextField: UITextField!
    
    override func set(_ data: Any) {
        guard let id = data as? String else { return }
        accountTextField.text = id
    }
}
