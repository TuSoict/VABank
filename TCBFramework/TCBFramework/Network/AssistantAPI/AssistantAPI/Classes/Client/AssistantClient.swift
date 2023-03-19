//
//  AssistantClient.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 01/06/2022.
//

import RxSwift
import Alamofire

public struct AssistantClient: AssistantProtocol {
    static var client: BaseClient = BaseClient()
    
    public init(){}
    
    public static func convertResponseToObject(jsonString: String)-> [String: Any] {
        do {
            if let json = jsonString.data(using: String.Encoding.utf8) {
                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String: AnyObject] {
                    return jsonData
                }
            }
        } catch {
            Log.debug(message: error.localizedDescription)
        }
        return ["":""]
    }
    
    public static func registerDevice(isDevMode: Bool,
                                      registrationData: String,
                                      deviceCert: String,
                                      signature: String,
                                      isFromDevice: Bool) -> Single<AppToken> {
        let params: [String: Any] = [
            "device_cert": deviceCert,
            "is_dev_mode": isDevMode,
            "registration_data": registrationData,
            "signature": signature,
            "is_from_device": isFromDevice
        ]
        return client.request(AssistantRouter.registerDevice(params: params))
            .flatMap({ (data: RegisterResponseModel) -> Single<AppToken> in
                NetworkAdapter.shared.appToken = data.response.appToken
                return .just(data.response.appToken)
            })
    }
    
    @discardableResult
    public static func setDeviceContext() -> Single<String> {
        let params: [String: Any] = [
            "context": [
                "access_token": NetworkAdapter.shared.deviceContext?.deviceCert ?? "ERROR_TOKEN",
                "va_gateway_token": NetworkAdapter.shared.appToken?.accessToken ?? "",
                "user_name": NetworkAdapter.shared.deviceContext?.userName ?? "",
            ],
        ]
        return client.request(AssistantRouter
            .setDeviceContext(deviceId: NetworkAdapter.shared.appToken?.deviceID ?? "", params: params))
        .flatMap({ (data: StringResponse) -> Single<String> in
            return .just(data.message)
        })
    }
    
    public static func pushMessage(message: String,
                                   vaAgenId: String,
                                   nlpFeature: [String],
                                   isSpoken: Bool) -> Single<String> {
        let sessionId = NetworkAdapter.shared.session_id ?? ""
        var params: [String: Any] = [
            "message": message,
            "va_agent_id": vaAgenId,
            "session_id": sessionId,
            "nlp_features": nlpFeature
        ]
        
        if isSpoken {
            let asrResult: [String: Any] = [
                "text" : message,
                "spoken_text" : message
            ]
            params[ "asr_result"] = asrResult
        }
        
        return client.request(AssistantRouter
            .pushMessage(deviceId: NetworkAdapter.shared.appToken?.deviceID ?? "",
                         params: params))
        .flatMap({ (response: PushMessageResponse) -> Single<String> in
            NetworkAdapter.shared.currentSessionId = sessionId
            return .just(response.messageId ?? "")
        })
    }
    
    public static func getVAResponse(by messageId: String) -> Single<VAResponse> {
        return client.request(AssistantRouter.getVAResponse(messageId: messageId,deviceId: NetworkAdapter.shared.appToken?.deviceID ?? ""))
    }
    
    public static func getVAResponse() -> Single<VAResponse> {
        return client.request(AssistantRouter
            .getVaResponseBySession(deviceId: NetworkAdapter.shared.appToken?.deviceID ?? "",
                                    sessionId: NetworkAdapter.shared.currentSessionId ?? ""))
    }
    
    
    public static func generateAudio(text: String,
                                     languageCode: String,
                                     voiceName: String,
                                     generator: String,
                                     acousticModel: String,
                                     style: String,
                                     ouputFormat: String) -> Single<AudioResponse> {
        let params: [String: Any] = [
            "text": text,
            "language_code": languageCode,
            "voice_name": voiceName,
            "generator": generator,
            "acoustic_model": acousticModel,
            "style": style,
            "output_format": ouputFormat
        ]
        return client.request(AssistantRouter.generateAudio(params: params))
    }
    
    public static func getAudio(_ sentenceId: String) -> Single<String> {
        return Single.just(NetworkAdapter.shared.environment.audioUrl + sentenceId)
    }
}
