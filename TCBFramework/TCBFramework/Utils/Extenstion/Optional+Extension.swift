//
//  Optional+Extension.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//
import UIKit

extension Optional {
    func stringValue() -> String {
        switch(self) {
        case .none:
            return ""
        case .some(let value):
            return value as? String ?? "\(value)"
        }
    }
    
    func intValue() -> Int {
        switch(self) {
        case .none:
            return 0
        case .some(let value):
            if let intValue = value as? Int {
                return intValue
            }
            if let doubleValue = value as? Double {
                return Int(doubleValue)
            }
            return 0
        }
    }
    
    func doubleValue() -> Double {
        switch(self) {
        case .none:
            return 0
        case .some(let value):
            if let intValue = value as? Int {
                return Double(intValue)
            }
            if let doubleValue = value as? Double {
                return doubleValue
            }
            return 0
        }
    }
    
    func boolValue() -> Bool {
        switch(self) {
        case .none:
            return false
        case .some(let value):
            return value as? Bool ?? false
        }
    }
    
    func arrayValue<T>(_ aClass: T.Type) -> [T] {
        switch(self) {
        case .none:
            return []
        case .some(let value):
            return value as? [T] ?? []
        }
    }
    
    func value<T>(defaultValue: T) -> T {
        switch(self) {
        case .none:
            return defaultValue
        case .some(let value):
            return value as? T ?? defaultValue
        }
    }
}
