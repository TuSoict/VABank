//
//  ImageCell.swift
//  BankAssistant
//
//  Created by Anonymous on 20/07/2022.
//

import UIKit

class ImageCell: BaseTableViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    
    override func set(_ data: Any) {
        guard let image = data as? String else { return }
        bgImageView.image = UIImage.by(name: image)
    }
}
