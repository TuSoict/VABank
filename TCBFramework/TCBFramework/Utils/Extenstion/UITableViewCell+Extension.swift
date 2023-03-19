//
//  UITableViewCell+Extension.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellReuseIdentifier: name)
        } else {
            register(aClass, forCellReuseIdentifier: name)
        }
    }
    
    func dequeue<T: UITableViewCell>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not register")
        }
        return cell
    }
    
}
