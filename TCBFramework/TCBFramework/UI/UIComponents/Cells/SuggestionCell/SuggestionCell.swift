//
//  SuggestionCell.swift
//  TCB-Framework
//
//  Created by vinbigdata on 03/03/2023.
//

import UIKit

class SuggestionCell: BaseTableViewCell {

    @IBOutlet var SuggestLable: UILabel!
    @IBOutlet var suggestionImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
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
    
    static func heightForRow() -> Double {
        return 50
    }
    
    override func set(_ data: Any) {
        let suggestDataDict = data as! [String:String]
        
        if suggestDataDict.has(key: "value") {
            SuggestLable.text = suggestDataDict["value"].stringValue()
        }
        
        if suggestDataDict.has(key: "icon") {
            let icon_url_string = suggestDataDict["icon"].stringValue()
            let iconElementsDefault = [ImagesBundleFile.icTransfer, ImagesBundleFile.icPayBill, ImagesBundleFile.icATM, ImagesBundleFile.icStatement]
            if iconElementsDefault.contains(ImagesBundleFile(rawValue: icon_url_string) ?? .icVoice) {
                suggestionImageView.image = UIImage.getImage(imagesBundleFile: ImagesBundleFile(rawValue: icon_url_string) ?? .icTransfer)
            } else {
//                suggestionImageView.sd_setImage(with: URL(string: icon_url_string), placeholderImage: UIImage.getImage(imagesBundleFile: .icTransfer))
            }
        }
    }
    
}
