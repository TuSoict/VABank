//
//  BaseDataSource.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation
import UIKit

class BaseDataSource: NSObject {
    weak var tableView: UITableView!
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
}
