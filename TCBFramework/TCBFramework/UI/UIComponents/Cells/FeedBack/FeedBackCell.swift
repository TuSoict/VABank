//
//  FeedBackCell.swift
//  BankAssistant
//
//  Created by Anonymous on 18/07/2022.
//

import UIKit

class FeedBackCell: BaseTableViewCell {

    @IBOutlet weak var claimLabel: UILabel!

    override func set(_ data: Any) {
        guard let text = data as? String else { return }
        claimLabel.text = text
    }
}
