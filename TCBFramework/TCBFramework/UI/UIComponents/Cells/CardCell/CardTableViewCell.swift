//
//  CardTableViewCell.swift
//  BankAssistant
//
//  Created by nguyen.tuan.hai on 15/07/2022.
//

import UIKit

class CardTableViewCell: BaseTableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var iconChecked: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func set(_ data: Any) {
        guard let card = data as? Card else { return }
        iconChecked.isHidden = !card.isLock
        iconImageView.image = UIImage.by(name: card.type.image)
        moneyLabel.text = card.money
        typeLabel.text = card.type.rawValue
    }
}
