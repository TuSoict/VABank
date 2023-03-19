//
//  LoginViewModel.swift
//  BankAssistant
//
//  Created by nguyen.tuan.hai on 14/07/2022.
//

import Foundation

final class LoginViewModel: BaseViewModel {
    
    func registerDevice() {
        AssistantService.shared.registerDevice(deviceCert: "token app", userName: "NghiaLM")
    }
}
