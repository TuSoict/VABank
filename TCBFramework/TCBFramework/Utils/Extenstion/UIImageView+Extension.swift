//
//  UIImageView+Extension.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import UIKit
//import SDWebImage

extension UIImageView {
    
//    func setImage(_ url: String) {
//        sd_cancelCurrentImageLoad()
//        sd_imageIndicator = SDWebImageActivityIndicator.white
//        sd_setImage(with: URL(string: url), placeholderImage: nil)
//    }
}

extension UIImage {
    
    static func getImage(imagesBundleFile: ImagesBundleFile) -> UIImage? {
        let bundle = Constants.appBundle
        return UIImage(named: imagesBundleFile.rawValue, in: bundle, compatibleWith: nil)
    }
    static func getImage(nameFile:String) -> UIImage? {
        let bundle = Constants.appBundle
        return UIImage(named: nameFile, in: bundle, compatibleWith: nil)
    }
}
