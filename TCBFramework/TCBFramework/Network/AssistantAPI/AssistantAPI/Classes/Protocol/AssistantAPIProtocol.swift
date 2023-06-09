//
//  AssistantAPIProtocol.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 01/06/2022.
//

import Foundation
import RxSwift

public protocol AssistantProtocol {
    /**
     Register deveice return token.
     AssistantAPI will store those token information for futher request
     */
    static func registerDevice(isDevMode: Bool,
                        registrationData: String,
                        deviceCert: String,
                        signature: String,
                        isFromDevice: Bool) -> Single<AppToken>
    /**
     Set device context
     */
    static func setDeviceContext() -> Single<String>
    /**
     send push message to server to get messageID - using messageID to get VA Response
     */
    static func pushMessage(message: String, vaAgenId: String, nlpFeature: [String], isSpoken: Bool) -> Single<String>
    /**
     get VAResponse by messageID
     */
    static func getVAResponse(by messageId: String) -> Single<VAResponse>
    
    /**
     get VAResponse by current sessionId
     */
    static func getVAResponse() -> Single<VAResponse>
    
    /**
     Generate Audio
     */
    static func generateAudio(text: String,
                              languageCode: String,
                              voiceName: String,
                              generator: String,
                              acousticModel: String,
                              style: String,
                              ouputFormat: String) -> Single<AudioResponse>
    }
