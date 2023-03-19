//
//  BankAssistantViewController+ScreenSuggest.swift
//  TCB-Framework
//
//  Created by Ly Nghia on 3/8/23.
//

import UIKit

extension BankAssistantViewController {
    
    func setHeightStackViewSupportSuggestView() {
        // set image view
        if self.heightTitleLableContraints.constant != 20 {
            self.titleLabel.isHidden = true
            self.heightTitleLableContraints.constant = 20;
        }
        if self.heightStateImageViewContraints.constant == 0 {
            self.heightStateImageViewContraints.constant = 80;
        }
        if self.heightWarningViewContraints.constant == 0 {
            self.heightWarningViewContraints.constant = 80;
        }
    }
    
    func setDefaultSuggestView() {
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            self.cancelTimer()
            
            self.setHeightStackViewSupportSuggestView()
            
            self.titleLabel.isHidden = true
            self.stateImageView.image = nil
            self.messageLabel.isHidden = true
            
            self.warningLable.isHidden = false
            self.warningLable.text = messageString.canIHelpYou.rawValue
            self.warningLable.font = .systemFont(ofSize: 15, weight: .regular)
            
            self.detailWaringLable.isHidden = true
        }
    }
    
    func setSuggestView(icon: ImagesBundleFile, warning: String, detailWarning: String) {
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            self.setHeightStackViewSupportSuggestView()
            
            self.stateImageView.image = UIImage.getImage(imagesBundleFile: icon)
            
            self.warningLable.text = warning
            self.warningLable.isHidden = false
            self.warningLable.font = .systemFont(ofSize: 24, weight: .semibold)
            self.detailWaringLable.isHidden = false
            self.detailWaringLable.text = detailWarning
            
            // handle ignore cancelTimer with icProcessing
            if icon == .icProcessing {
                if self.heightTitleLableContraints.constant < 80 {
                    self.heightTitleLableContraints.constant = 120;
                }
                self.tableView.reloadData()
            } else {
                self.cancelTimer()
            }
        }
    }
    
    func hiddenAllAttributes() {
        self.cancelTimer()
        if self.heightTitleLableContraints.constant != 0 {
            self.heightTitleLableContraints.constant = 0;
        }
        if self.heightStateImageViewContraints.constant != 0 {
            self.heightStateImageViewContraints.constant = 0;
        }
        if self.heightWarningViewContraints.constant != 0 {
            self.heightWarningViewContraints.constant = 0;
        }
        self.waveView.isHidden = true;
    }
    
}
