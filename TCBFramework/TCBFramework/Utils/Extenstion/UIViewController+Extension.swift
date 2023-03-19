//
//  UIViewController+Extension.swift
//  BankAssistant
//
//  Created by SuperT on 16/07/2022.
//

import Foundation
import UIKit

extension UIViewController {
    public var isViewVisible: Bool {
        if isViewLoaded {
            return view.window != nil
        }
        return false
    }
    
    class func getXibVC() -> Self {
        return getXibViewController(self)
    }
}

private func getXibViewController<T: UIViewController>(_ viewControllerClassName: T.Type) -> T {
    let name = String(describing: T.self)
    if Bundle.main.path(forResource: name, ofType: "nib") == nil
        && Bundle.main.path(forResource: name, ofType: "xib") == nil {
        fatalError("\(name) is not registed")
    }
    return T(nibName: name, bundle: nil)
}
