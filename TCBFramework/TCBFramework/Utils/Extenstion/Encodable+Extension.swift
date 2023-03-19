//
//  Encodable+Extension.swift
//  BankAssistant
//
//  Created by SuperT on 15/07/2022.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any] {
        var dic: [String: Any] = [:]
        if let data = try? JSONEncoder().encode(self) {
            dic = (try? JSONSerialization
                .jsonObject(with: data, options: .mutableContainers))
            .flatMap { $0 as? [String: Any] } ?? [:]
        }
        return dic
    }
    
    var jsonString: String {
        guard let data = jsonData else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
}
