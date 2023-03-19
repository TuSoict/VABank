//
//  NavigationView.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import UIKit

class NavigationView: ViewWithXib {
    
    @IBOutlet weak var iconButtonNavigation: UIButton!
    
    var isVAHome: Bool = true
    var onBack: (() -> Void)?
    
    func onUpdateUIVAHome(isVAHomeStatus: Bool) {
        self.isVAHome = isVAHomeStatus
        if (isVAHomeStatus) {
            self.iconButtonNavigation.setImage(UIImage.getImage(imagesBundleFile: .icExits), for: .normal)
        } else {
            self.iconButtonNavigation.setImage(UIImage.getImage(imagesBundleFile: .icArrowBack), for: .normal)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        onBack?()
    }
}
