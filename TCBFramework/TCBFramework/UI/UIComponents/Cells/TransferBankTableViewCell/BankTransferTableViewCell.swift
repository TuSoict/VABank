//
//  BankTransferTableViewCell.swift
//  TCB-Framework
//
//  Created by vinbigdata on 16/03/2023.
//

import UIKit

class BankTransferTableViewCell: BaseTableViewCell {

    @IBOutlet var warningUILabel: UILabel!
    @IBOutlet var bgView: UIView!
    @IBOutlet var avaBankImageView: UIImageView!
    @IBOutlet var bankNumberUILable: UILabel!
    @IBOutlet var bankNameUILabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.dropShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func set(_ data: Any) {
        
    }
    
    
    static func heightForRow() -> Double {
        return 100
    }
    
    
}
