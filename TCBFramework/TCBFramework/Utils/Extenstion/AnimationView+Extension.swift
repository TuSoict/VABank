//
//  AnimationView+Extension.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation
import Lottie

extension Lottie.AnimationView {
    static func by(name: String) -> Lottie.AnimationView {
        return Lottie.AnimationView(name: name)
    }
}
