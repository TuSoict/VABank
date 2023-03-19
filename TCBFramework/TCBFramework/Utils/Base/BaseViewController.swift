//
//  BaseViewController.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation
import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
    }
    
    func setupUI() {}
    func setupEvent() {}
    
    func backAction() {
        if self.navigationController?.popViewController(animated: true) == nil {
            self.dismiss(animated: true)
        }
    }
    
    deinit {
        Log.debug(message: "de-init " + self.className, mode: .debug)
    }
}

extension BaseViewController {
    func push(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func present(vc: UIViewController, completion: (() -> Void)? = nil) {
        self.present(vc, animated: true, completion: completion)
    }
    
    func showToast(message : String) {

        let font = UIFont.systemFont(ofSize: 13)
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.center = self.view.center
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
