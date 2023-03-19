//
//  BankTableViewCell.swift
//  TCB-Framework
//
//  Created by vinbigdata on 07/03/2023.
//

import UIKit

class BankTableViewCell: BaseTableViewCell {
    @IBOutlet var nameUILabel: UILabel!
    
    @IBOutlet var avatarUIImageView: UIImageView!
    @IBOutlet var descUILabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func heightForRow() -> Double {
        return 80
    }
    
    
    override func set(_ data: Any) {
        let bank = data as! Banks
        
        if bank.name!.count > 0 {
            self.nameUILabel.text = bank.name
        }
        if bank.desc!.count > 0 {
            self.descUILabel.text = bank.desc
        }
        
        if bank.icon!.count > 0 {
            self.avatarUIImageView.image = UIImage.getImage(nameFile:bank.icon!)
        }
        
    }
}
