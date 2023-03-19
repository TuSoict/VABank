//
//  BanksAssistantViewController+TransferMoney.swift
//  TCB-Framework
//
//  Created by vinbigdata on 07/03/2023.
//

import Foundation
import UIKit

extension BankAssistantViewController {
    func setupViewInCasePayObject ( message:BotMessage?) {
        let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black,]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]

        let firstString = NSMutableAttributedString(string: "Bạn muốn chuyển khoản tới ", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "ngân hàng nào ? ", attributes: secondAttributes)

        firstString.append(secondString)
        
        if self.heightTitleLableContraints.constant != 80 {
            self.heightTitleLableContraints.constant = 80;
            self.titleLabel.isHidden = false
            self.titleLabel.attributedText = firstString
        }
        
        if self.heightStateImageViewContraints.constant != 0 {
            self.heightStateImageViewContraints.constant = 0;
        }
        
        if self.heightWarningViewContraints.constant != 0 {
            self.heightWarningViewContraints.constant = 0;
        }
        
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.waveView.isHidden = true
            self.view.layoutIfNeeded()
        }
        
        self.tableView.isScrollEnabled = true;
        setDataSource(message!)
    }
    
    func setupViewInCaseBankSelected(message:BotMessage?) {
        let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black,]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]

        let firstString = NSMutableAttributedString(string: "Bạn muốn chuyển khoản tới ", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "tài khoản số ? ", attributes: secondAttributes)

        firstString.append(secondString)
        
        if self.heightStateImageViewContraints.constant != 0 {
            self.heightStateImageViewContraints.constant = 0;
        }
        
        if self.heightWarningViewContraints.constant != 0 {
            self.heightWarningViewContraints.constant = 0;
        }
        
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.waveView.isHidden = true
            self.stateImageView.image = nil
            self.titleLabel.isHidden = false
            self.titleLabel.attributedText = firstString
            self.view.layoutIfNeeded()
        }

//        var value = BotMessage.generateBotMessageValue(cmd: .payBankSelect, velocity: .continuous, data: "")
//        let message = BotMessage(type: BotMessageType.text,value: value, extraData: bank)
        self.setDataSource(message!)
        
    }
    
    
    
    
    
}
