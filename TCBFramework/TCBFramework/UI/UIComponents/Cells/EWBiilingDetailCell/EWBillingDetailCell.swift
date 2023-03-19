//
//  EWBillingDetailCell.swift
//  BankAssistant
//
//  Created by SuperT on 18/07/2022.
//

import UIKit

class EWBillingDetailCell: BaseTableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    override func set(_ data: Any) {
        guard let bill = data as? EWBilling else { return }
        let attribute: NSMutableAttributedString
        switch bill.type {
        case .electric:
            iconImageView.image = UIImage.getImage(imagesBundleFile: .icElectronic)
            attribute = NSAttributedString
                .makeWith(color: Colors.black, weight: .medium, ofSize: 14, "Điện lực Hà nội")
        case .water:
            iconImageView.image = UIImage.getImage(imagesBundleFile: .icWater)
            attribute = NSAttributedString
                .makeWith(color: Colors.black, weight: .medium, ofSize: 14, "Nước sạch Hà nội")
        }
        
        if !bill.name.isEmpty {
            attribute
                .appendWith(color: Colors.black, weight: .regular, ofSize: 12, "\n" + bill.name)
        }
        
        if !bill.code.isEmpty {
            attribute
                .appendWith(color: Colors.black, weight: .medium, ofSize: 12, "\n" + bill.code)
        }
        
        if !bill.date.isEmpty {
            attribute
                .appendWith(color: Colors.black, weight: .regular, ofSize: 12, "\nKỳ hạn: " + bill.date)
        }

        detailLabel.attributedText = attribute.addLineSpacing(5)
        
        moneyLabel.attributedText = NSAttributedString
            .makeWith(color: Colors.black, weight: .regular, ofSize: 12, "VND ")
            .appendWith(color: Colors.black, weight: .bold, ofSize: 14, bill.money)
        
    }
}
