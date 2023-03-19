//
//  TransactionItemCell.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import UIKit

class TransactionItemCell: BaseTableViewCell {
    @IBOutlet weak var avatarImageView: AvatarView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    override func set(_ data: Any) {
        guard let tx = data as? TransactionData else { return }
        nameLabel.text = tx.name
        timeLabel.text = tx.time
        if tx.avatar.hasPrefix("ic_avatar") {
            avatarImageView.setBackground(tx.avatar)
        } else {
            avatarImageView.setIcon(tx.avatar)
        }
        if tx.isPlus {
            moneyLabel.text = "+VND " + tx.money
            moneyLabel.textColor = Colors.green
        } else {
            moneyLabel.text = "-VND " + tx.money
            moneyLabel.textColor = Colors.oragne
        }
    }
}

