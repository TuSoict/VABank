//
//  BalanceInfoTableViewCell.swift
//  BankAssistant
//
//  Created by nguyen.tuan.hai on 15/07/2022.
//

import UIKit

class BalanceInfoTableViewCell: BaseTableViewCell {

    func set(_ tx: TransactionData) {
//        nameLabel.text = tx.name
//        timeLabel.text = tx.time
//        moneyLabel.text = tx.money
//        avatarImageView.setBackground(tx.avatar)
    }
    
}

struct BalanceInfoData {
    var balance: Int = 2_0000_000
    var incom: Int = 2_0000_000
    var spending: Int = 1_2000
    var cards = [CardData]()
}

struct CardData {
    var cardName: String = "Visa"
    var cardBalance: Int = 1000_000
    var cardImageURL: String
}
