//
//  AppUserDefault.swift
//  BankAssistant
//
//  Created by nguyen.tuan.hai on 19/07/2022.
//

import Foundation

protocol AppUserDefaultsProtocol: AnyObject {

    var didShowOnboarding: Bool { get set }
}

class AppUserDefaults {
    
    static let shared = AppUserDefaults()

    private let defaults = UserDefaults.standard

    private let didShowOnboardingKey = "DidShowOnboarding"
    
}

extension AppUserDefaults: AppUserDefaultsProtocol {

    var didShowOnboarding: Bool {
        get {
            return defaults.object(forKey: didShowOnboardingKey) as? Bool ?? false
        }
        set {
            defaults.set(newValue, forKey: didShowOnboardingKey)
        }
    }
}
