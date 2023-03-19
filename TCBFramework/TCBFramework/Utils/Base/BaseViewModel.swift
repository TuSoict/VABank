//
//  BaseViewModel.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation
import RxSwift

class BaseViewModel: Any {
    
    init() {
        setupData()
        setupEvent()
    }
    
    func setupData() {}
    func setupEvent() {}
    
    var disposeBag = DisposeBag()
    
    deinit {
        Log.debug(message: "de-init \(self)", mode: .debug)
    }
}
