//
//  Log.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation

enum LogMode: Int {
    case all
    case stg
    case debug
    case release
}

struct Log {
    static func debug(message: String, function: String = #function, mode: LogMode = .debug) {
        guard Log.mode != .release else { return }
        guard mode.rawValue >= self.mode.rawValue else { return }
        #if DEBUG
            let date = Date()
            print("\(date) Func: \(function) : \(message)")
        #endif
    }
    
    static var mode: LogMode = .release
}
