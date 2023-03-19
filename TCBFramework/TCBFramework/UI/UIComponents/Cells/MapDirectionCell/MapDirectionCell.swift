//
//  MapDirectionCell.swift
//  BankAssistant
//
//  Created by SuperT on 20/07/2022.
//

import UIKit

class MapDirectionCell: BaseTableViewCell {
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var mapImageView: UIImageView!
    
    override func set(_ data: Any) {
        guard let image = data as? String else { return }
        topSpace.constant = image.contains("location") ? 0 : 100
        mapImageView.image = UIImage.by(name: image)
    }
    
}
