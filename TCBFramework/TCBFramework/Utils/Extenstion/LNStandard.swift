//
//  LNStandard.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation

protocol LNStandard { }

func run<T>(_ block:() -> T) -> T {
    return block()
}

func with<T, E>(_ source:T, _ block:(T) -> E) -> E {
    return block(source)
}

extension LNStandard {
    func `let`(_ block:(Self) -> ()) {
        block(self)
    }
    
    @discardableResult
    func apply(_ block:(Self) -> ()) -> Self {
        block(self)
        return self
    }
    
    @discardableResult
    func run<T>(_ block: (Self) -> T) -> T {
        return block(self)
    }
    
    @discardableResult
    func takeIf(_ predicate:(Self) -> Bool) -> Self? {
        return predicate(self) ? self : nil
    }
}

extension Dictionary: LNStandard{}
extension Array: LNStandard {}
extension NSObject: LNStandard {}
extension String: LNStandard {}
extension Decimal: LNStandard {}
extension Data: LNStandard {}
extension Bool: LNStandard {}
extension Double: LNStandard {}
extension Int: LNStandard {}

extension Array {
    func all(_ predicate: (Element) -> Bool) -> Bool {
        if isEmpty { return true }
        for element in self {
            if !predicate(element) { return false }
        }
        return true
    }
    
    func any(_ predicate: (Element) -> Bool) -> Bool {
        if isEmpty { return false }
        for element in self {
            if predicate(element) { return true }
        }
        return false
    }
    
    func onEach(_ body: (Element) -> ()) -> Self {
        forEach { body($0) }
        return self
    }
}
extension Optional {
    func unwrap(_ block:(Wrapped) -> ()) {
        if let value = self {
            block(value)
        }
    }
    func unwrap() throws -> Wrapped {
        guard let value = self else {throw NSError()}
        return value
    }
}

extension LNStandard {
    mutating func update() {
        let temp = self
        self = temp
    }
}
