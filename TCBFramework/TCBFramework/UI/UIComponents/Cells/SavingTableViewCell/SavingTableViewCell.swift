//
//  SavingTableViewCell.swift
//  TCB-Framework
//
//  Created by Ly Nghia on 3/13/23.
//

import UIKit

class SavingTableViewCell: BaseTableViewCell {

    @IBOutlet var detailUILable: UILabel!
    @IBOutlet var titleUILable: UILabel!
    @IBOutlet var avaImageView: UIImageView!
    @IBOutlet var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.bgView.dropShadow()

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       // fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func set(_ data: Any) {
        let suggestDataDict = data as! [String:String]
        print(suggestDataDict)
        
        if suggestDataDict.has(key: "title") {
            titleUILable.text = suggestDataDict["title"].stringValue()
        }
        
        if suggestDataDict.has(key: "description") {
            detailUILable.text = suggestDataDict["description"].stringValue()
        }
        
        if suggestDataDict.has(key: "icon") {
            let icon_url_string = suggestDataDict["icon"].stringValue()
            let iconElementsDefault = [ImagesBundleFile.icTransfer, ImagesBundleFile.icPayBill, ImagesBundleFile.icMB, ImagesBundleFile.icStatement]
            if iconElementsDefault.contains(ImagesBundleFile(rawValue: icon_url_string) ?? .icVoice) {
                avaImageView.image = UIImage.getImage(imagesBundleFile: ImagesBundleFile(rawValue: icon_url_string) ?? .icTransfer)
            } else {
//                avaImageView.sd_setImage(with: URL(string: icon_url_string), placeholderImage: UIImage.getImage(imagesBundleFile: .icTransfer))
            }
        }
        
        if suggestDataDict.has(key: "color") {
            let colorString = suggestDataDict["color"].stringValue()
            let cellColor = UIColor(hexString: colorString)
            self.bgView.backgroundColor = cellColor
        }
    }
    
}

extension UIView {

    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2, height: 5)
        layer.shadowRadius = 1
        layer.cornerRadius = 8
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
}
