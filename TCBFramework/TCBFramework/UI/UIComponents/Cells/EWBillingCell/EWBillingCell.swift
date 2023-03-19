//
//  EWBillingCell.swift
//  BankAssistant
//
//  Created by Anonymous on 18/07/2022.
//

import UIKit

class EWBillingCell: BaseTableViewCell {

    @IBOutlet weak var watterLabel: UILabel!
    @IBOutlet weak var electricLabel: UILabel!
    @IBOutlet weak var newLabel: UILabel!
    
    override func setupUI() {
        watterLabel.attributedText = NSAttributedString
            .makeWith(color: Colors.black, weight: .medium, ofSize: 14, "Điện lực Hà nội")
            .appendWith(color: Colors.black, weight: .regular, ofSize: 12, "\nPhạm Văn Cường")
            .appendWith(color: Colors.black, weight: .medium, ofSize: 12, "\n12686868")
            .addLineSpacing(5)

        electricLabel.attributedText = NSAttributedString
            .makeWith(color: Colors.black, weight: .medium, ofSize: 14, "Nước sạch Hà nội")
            .appendWith(color: Colors.black, weight: .regular, ofSize: 12, "\nPhạm Văn Cường")
            .appendWith(color: Colors.black, weight: .medium, ofSize: 12, "\nPD123456789101")
            .addLineSpacing(5)
        
        newLabel.attributedText = NSAttributedString
            .makeWith(color: Colors.black, weight: .medium, ofSize: 14, "Vinaphone trả sau")
            .appendWith(color: Colors.black, weight: .regular, ofSize: 12, "\n09123456789")
            .appendWith(color: Colors.black, weight: .medium, ofSize: 12, "\nHoá đơn trước: VND 500,000")
            .addLineSpacing(5)
    }
}
