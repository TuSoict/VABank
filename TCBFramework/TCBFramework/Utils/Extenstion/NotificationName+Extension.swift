//
//  NotificationName+Extension.swift
//  BankAssistant
//
//  Created by nguyen.tuan.hai on 20/07/2022.
//

import Foundation

enum AIBankNotification: CaseIterable {

    case requestRecordPermission

    var name: Notification.Name {
        return Notification.Name("AIBank" + "." + String(describing: self))
    }
}
