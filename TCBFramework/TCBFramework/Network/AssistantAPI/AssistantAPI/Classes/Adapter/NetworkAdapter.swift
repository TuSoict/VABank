//
//  NetworkAdapter.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 01/06/2022.
//

import Foundation
public protocol NetworkEnv {
    var baseUrl: String { get }
    var vaBaseUrl: String { get }
    var audioUrl: String { get }
    var webSocketUrl: String { get }
}

public class NetworkAdapter {
    public static var shared: NetworkAdapter = NetworkAdapter()
    public var environment: NetworkEnv!
    var appToken: AppToken?
    var currentSessionId: String?
    var VAagentId = "1677644574060429428"
    var userAccessToken: String?
    var deviceContext: DeviceContext?
    
    var session_id: String? {
        if let deviceId = appToken?.deviceID {
            let timeStamp = String(format: "%.0f", NSDate().timeIntervalSince1970.rounded())
            Log.debug(message: "DEBUG: sessionId = \(deviceId)_\(timeStamp)")
            return "\(deviceId)_\(timeStamp)"
        }
        return nil
    }
    
    init() {}
    
    public func setupAdapter(environment: NetworkEnv) {
        self.environment = environment
    }
    
    func setAppToken(appToken: AppToken) {
        self.appToken = appToken
    }
    
    func getAppToken() -> AppToken? {
        return self.appToken
    }
    
    func setDeviceContext(deviceContext: DeviceContext) {
        self.deviceContext = deviceContext
    }
    
    func getDeviceContext() -> DeviceContext? {
        return self.deviceContext
    }
            
}
