//
//  BankTransferModel.swift
//  TCB-Framework
//
//  Created by vinbigdata on 07/03/2023.
//

import Foundation

struct Banks: Codable {
    var name: String?
    var bid: String?
    var icon: String?
    var desc: String?
}

struct TCBBanks: Codable {
    var bank : [Banks]?
}
