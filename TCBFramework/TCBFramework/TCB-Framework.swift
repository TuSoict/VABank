//
//  TCB-Framework.swift
//  TCB-Framework
//
//  Created by vinbigdata on 28/02/2023.
//

import Foundation
import UIKit


public class TCBFramework : NSObject {
    
    private let dataFlowManager = DataFlowManager.shared
    private var nvController:UIViewController;
    
    
    //MARK: public API
    /*
     * Initialize VA bank instance
     * @navigationController: top ViewController
     */
    
    public init(navigationController:UIViewController) {
        self.nvController = navigationController
        super.init()
    }
    
    /*
     * public classes
     * This func used to start VA Bank
     * required: deviceCert & userName
     * @deviceCert: app access token access to server 3rd.
     * @userName: user name
     */
    public func startBankAssistant(deviceCert: String, userName: String) {
        self.start(deviceCert: deviceCert, userName: userName)
    }
    
    /*
     * Reset VA Bank
     * This func is used to reset VA Bank assistant.
     * If you have any strugge, lets call reset to fix it
     */
    public func reset() {
        self.dataFlowManager.resetData()
    }
    
    
    /*
     * Stop VA Bank
     * This func is used to stop VA Bank
     * VA Bank will stop once you invoke this func
     */
    public func stop() {
        self.dataFlowManager.stopAssistant()
    }
    
    /*
     * Manual open VA Bank from action of Users.
     *
     */
    public func openBankAssistant() {
        dataFlowManager.openBankAssistant(navigation: self.nvController) {}
    }
    
   private func start(deviceCert: String, userName: String) {
        self.dataFlowManager .setRootViewControllerForBankAssistant(rootViewControler: self.nvController)
        dataFlowManager.registerDeviceWithAccessToken(deviceCert: deviceCert, userName: userName)
       dataFlowManager.startWakeupWord()
    }
    
}
