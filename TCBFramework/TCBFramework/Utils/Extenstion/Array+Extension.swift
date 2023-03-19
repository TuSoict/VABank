//
//  Array+Extension.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import UIKit

extension Array {
    func safeValue(at index: Int) -> Element? {
        if index >= 0 && index < self.count {
            return self[index]
        } else {
            return nil
        }
    }
    
    func getLast(offset: Int) -> Element? {
        guard self.count > offset else { return nil }
        return self.safeValue(at: self.count - offset - 1)
    }
    
    var isNotEmpty: Bool { return !isEmpty }
}
