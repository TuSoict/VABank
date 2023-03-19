//
//  NSObject+Extension.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation


extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
