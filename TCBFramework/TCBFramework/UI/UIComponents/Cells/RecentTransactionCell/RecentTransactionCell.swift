//
//  RecentTransactionCell.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import UIKit

class RecentTransactionCell: BaseTableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var txDetailLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    override func set(_ data: Any) {
        guard let tx = data as? TransactionData else { return }
        avatarImageView.image = UIImage(named: tx.avatar)
        nameLabel.text = tx.name
        phoneLabel.text = tx.phone
        txDetailLabel.attributedText = NSAttributedString
            .makeWith(color: Colors.black, weight: .medium, ofSize: 24, "VND " + tx.money)
            .appendWith(color: Colors.black, weight: .regular, ofSize: 14, "\nChuyển tiền")
            .addLineSpacing(16)
    }
}
