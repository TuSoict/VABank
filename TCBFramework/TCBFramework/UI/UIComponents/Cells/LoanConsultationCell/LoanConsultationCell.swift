//
//  LoanConsultationCell.swift
//  BankAssistant
//
//  Created by Anonymous on 18/07/2022.
//

import UIKit

class LoanConsultationCell: BaseTableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func set(_ data: Any) {
        guard let loan = data as? Loan else { return }
        iconImageView.image = UIImage.by(name: loan.avatar)
        contentLabel.attributedText = NSAttributedString
            .makeWith(color: Colors.violet, weight: .medium, ofSize: 16, loan.title)
            .appendWith("\n")
            .appendWith(color: Colors.black, weight: .medium, ofSize: 16, loan.title)
            .addLineSpacing(10)
    }
}
