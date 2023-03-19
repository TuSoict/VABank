//
//  LoanAmountCell.swift
//  BankAssistant
//
//  Created by Anonymous on 18/07/2022.
//

import UIKit

class LoanAmountCell: BaseTableViewCell {

    @IBOutlet weak var paidLabel: UILabel!
    @IBOutlet weak var loanLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    override func setupUI() {
        loanLabel.text = ""
        periodLabel.text = ""
    }
    
    override func set(_ data: Any) {
        guard let data = data as? LoanDetail else { return }
        paidLabel.text = data.bePaid.isEmpty ? "0" : data.bePaid.toMoney()
        loanLabel.text = data.amount.toMoney()
        periodLabel.text = data.period
    }
}
