//
//  DataFlowManager+config.swift
//  TCB-Framework
//
//  Created by vinbigdata on 28/02/2023.
//

import Foundation
//import IQKeyboardManagerSwift
//import SDWebImageSVGNativeCoder

extension DataFlowManager {
    func setupNetwork() {
        struct AppEnvironment: NetworkEnv {
            var baseUrl: String {
                return "https://tcb-demo.vinbase.ai/"
            }
            
            var vaBaseUrl: String {
                return "https://tcb-demo.vinbase.ai/"
            }
            
            var audioUrl: String {
                return baseUrl + "api/v1/tts/results/mp3/"
            }
            
            var webSocketUrl: String {
                return "wss://tcb-demo.vinbase.ai/api/v2/asr_bank/stream"
            }
        }
        
        NetworkAdapter.shared.setupAdapter(environment: AppEnvironment())
    }
    
    func setupIQKeyboard() {
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = false
//        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
//        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func registerSVGCoder() {
//        let SVGCoder = SDImageSVGNativeCoder.shared
//        SDImageCodersManager.shared.addCoder(SVGCoder)
    }
}
