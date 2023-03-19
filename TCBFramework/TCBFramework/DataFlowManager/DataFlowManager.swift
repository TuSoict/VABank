//
//  DataFlowManager.swift
//  TCB-Framework
//
//  Created by vinbigdata on 27/02/2023.
//

import Foundation
import UIKit

enum StateAssistant {
    case startingStateAssistant
    case activeStateAssistant
    case processingStateAssistant
    case failedStateAssistant
}


class DataFlowManager {
    static let shared = DataFlowManager()
    var exViewController:UIViewController?
    var banks:TCBBanks?
    var isOpenBankAssistant:Bool?
    let processing_time :Int = 3
    let fail_time:Int = 6
    
    var stateOfAssistant:StateAssistant = .startingStateAssistant
    var stateOfViViVelocity:Velocity = .immediate
    var flowDataQueue  = DispatchQueue(label:"DataFlow")
    private var reachability : Reachability!

    init() {
        self.isOpenBankAssistant = false;
        self.setupNetwork()
        self.setupIQKeyboard()
        self.registerSVGCoder()
        self.loadResources()
        self.observeReachability()
    }

    func startWakeupWord () {
        Assistant.shared.reset()
        Assistant.shared.start()
        self.changeStateAssistant(state: .startingStateAssistant)
    }
    
    func registerDeviceWithAccessToken (deviceCert: String, userName: String) {
        if deviceCert.count > 0 && userName.count > 0 {
            AssistantService.shared.registerDevice(deviceCert: deviceCert, userName: userName)
        }
    }
    
    func resetData() {
        Assistant.shared.reset()
        self.isOpenBankAssistant = false
        self.changeStateAssistant(state: .startingStateAssistant)
        self.changeStateViviVelocity(state: .immediate)
    }
    
    func stopAssistant() {
        self.exViewController = nil;
        Assistant.shared.stop()
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadResources () {
        flowDataQueue.async {
            self.loadBankDataFromLocal()
        }
    }
    
   private func loadBankDataFromLocal() {
        let path = Resouces.getLocalFile(name: "banks", fileType: "json")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decodedData = try JSONDecoder().decode(TCBBanks.self,
                                                       from: data)
            self.banks = decodedData;
            
        } catch {
            // handle error
            Log.debug(message: "error load Banks List")
        }
    }
    
    //MARK: - NETWORK
    func observeReachability(){
        self.reachability = try! Reachability()
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        do {
            try self.reachability!.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }

    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .cellular:
            print("Network available via Cellular Data.")
            break
        case .wifi:
            print("Network available via WiFi.")
            break
        case .unavailable:
            print("Network is  unavailable.")
            break
        }
    }
    
    
//MARK: - STATE DATA
    public func changeStateAssistant(state:StateAssistant) {
        if (self.stateOfAssistant == state) {return}
        self.stateOfAssistant = state
    }
    
    func changeStateViviVelocity(state:Velocity) {
        if self.stateOfViViVelocity == state {return}
        self.stateOfViViVelocity = state
    }
    
//MARK: - UI Flow
    func setRootViewControllerForBankAssistant(rootViewControler: UIViewController) {
        self.exViewController = rootViewControler;
    }
    
    func openBankAssistant(navigation: UIViewController?, completion: @escaping () -> ()) {
        let bankViewController = BankAssistantViewController()
        
        self.exViewController = navigation
        if self.isOpenBankAssistant! {
            completion();
        } else {
            
            // Force present OpenBankAssistantViewController
            bankViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.exViewController?.present(bankViewController, animated: true, completion:completion)
            
//            if ((self.exViewController?.navigationController) != nil) {
//                self.exViewController?.navigationController?.pushViewController(bankViewController, animated: true)
//                completion()
//            } else {
//                bankViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//                self.exViewController?.present(bankViewController, animated: true, completion:completion)
//            }
        }
        self.isOpenBankAssistant = true
    }
    
    
    
}
