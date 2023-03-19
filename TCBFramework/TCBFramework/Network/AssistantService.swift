//
//  AssistantService.swift
//  BankAssistant
//
//  Created by Anonymous on 15/07/2022.
//

import UIKit
import RxSwift
import Alamofire

protocol AssistantServiceProtocol {
    func registerDevice(deviceCert: String, userName: String)
    func pushMessage(_ text: String) -> Single<VAResponse>
}

final class AssistantService: AssistantServiceProtocol {
    
    public static let shared = AssistantService()
    
    var disposeBag = DisposeBag()
    
    func stopRequest() {
        disposeBag = DisposeBag()
    }
}

extension AssistantService {
    func registerDevice(deviceCert: String, userName: String) {
        
        #if DEBUG
        let deviceCode = self.randomString(length: 10)
        #else
        let deviceCode = UIDevice.current.identifierForVendor?.uuidString ?? ""
        #endif
        
        let agentId = NetworkAdapter.shared.VAagentId
        let systemVersion = UIDevice.current.systemVersion
        let device_cert = deviceCert

        let signature = "dT0lzAaA/eBnoDBuhjBL9eYaP0T9hZ2j6/t0+lF3Yk1xrLEnuX0y3T47Sdp1nu+W6IoGYzZPG/AFQSMe+o4GLE8wQzMoiY6mWFXKtyqpW+FWMOU5rLOmA7s6QMtTju++PYq8g+ui5g0b49iGPHhb69H1yRsMGI6rshFiHEH2DGzDQt0NNlcZx9ib9tMedjliQBXcypYJ0LDZB74tsn5qzItT8Ev5zS2GMX0LHHeCQPiOKb+QGOfFpXUztfgRIVIX9Mp8i44DVp6djTEcTaumvhMDj0vmnqKntzz5Gm9/SesjO3Xj04bA3m5giznpsC0vGm02y9HsmYkx8TU00qH2bg=="
//        let device_cert = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw+vqqi5bsGcr8HvKpuyy7axocLtRazXKCzoxtsx3J+kHzFDcoA96Nl0zOcz13sl6AO4gODAHmMCYOKlSmtkDBLgN8M7ZChNiHTYp6M2dQHQU8FHsN94Mjg8Lp/W+6x+6iprLiZM9d5UgliySY4qm+2XoJomsJdHf+M0LxngsuU1FFgXIWZ8e6V//ZE9MgmbGAT8VNGzo0QEQTYUF8EMTfXTuPOqWvk7lPqfbNKSpuWTDc6PmtZBWv/uynVIop96GkwQPcL3SQA1JbkacSvsohbjxCtgzYSFIGbrIxeyWkbVEkFv7yAjCanyhYj5+4UNOHzjZ2zLT9yvqe4vJ5k/E3wIDAQAB"
        
        
        //let device_cert = ""
        //1678449531565081365
        //1677647843336627487
        let regData = "{\"device_code\":\"\(deviceCode)\",\"asr_release_version_id\":\"1677644803725474158\",\"tts_release_version_id\":\"1677644831119902292\",\"va_release_version_id\":1678449531565081365,\"va_agent_id\":\(agentId),\"device_model\":\"DEFAULT MODEL\",\"device_info\":{\"model\":\"DEFAULT MODEL\",\"manufacture\":\"\",\"vin\":\"VIN_CODE_94e1a664c67eb277\",\"model_year\":0,\"fuel_capacity\":0,\"variant\":\"\",\"market\":\"\",\"car_type\":\"\",\"sw_version\":\"DEFAULT VERSION\",\"hw_version\":\"\(systemVersion)\"},\"device_type\":\"TECHCOMBANK\",\"device_public_key\":\"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDBn3iutFuUASQAu2nCIEbieJvZ93mmQgroyGJxaEGSQhxJP1CXWN79rAOfLpAD3zjlfn2\\/PC6qVtll2G\\/kZhqjcSsaErYMVp5UQDFzcM7EnPsZHXK9RL\\/tUD+KzEGSazLJlM1F9IEqipi2CaWKvsNXOJ1UaV1ntZ242o20uKualwIDAQAB\"}"
        
        
        AssistantClient.registerDevice(isDevMode: true,
                                       registrationData: regData,
                                       deviceCert: device_cert,
                                       signature: signature,
                                       isFromDevice: false)
        .subscribe { [weak self] appToken in
            Log.debug(message: "DEBUG: \(appToken)", mode: .debug)
            let deviceContext = DeviceContext(deviceCert: deviceCert, userName: userName)
            NetworkAdapter.shared.setDeviceContext(deviceContext: deviceContext)
            NetworkAdapter.shared.setAppToken(appToken: appToken)
                        
            self?.setDeviceContext(completion: nil)
        } onFailure: { error in
            print(error)
            Log.debug(message: "DEBUG: \(error)")
        }.disposed(by: disposeBag)
    }
    
    func setDeviceContext(completion: ((String?) -> Void)? = nil) {
        AssistantClient.setDeviceContext()
            .subscribe(onSuccess: { message in
                completion?(message)
                
                print(message)
                Log.debug(message: "DEBUG DEVICE CONTEXT: \(message)")
            }, onFailure: { error in
                completion?(nil)
                print(error)
                Log.debug(message: "DEBUG DEVICE CONTEXT: \(error)")
            }).disposed(by: self.disposeBag)
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}

extension AssistantService {
    func pushMessage(_ text: String) -> Single<VAResponse> {
        func responseBy(_ messageId: String) -> Single<VAResponse> {
            return AssistantClient.getVAResponse(by: messageId)
                .flatMap { response -> Single<VAResponse> in
                    if response.vaData?.isAllDone == true {
                        return Single.just(response)
                    } else {
                        sleep(1)
                        return responseBy(messageId)
                    }
            }
        }
        
        return AssistantClient
            .pushMessage(message: text,
                         vaAgenId: NetworkAdapter.shared.VAagentId,
                         nlpFeature: ["DIALOG"],
                         isSpoken: true)
            .flatMap { messageId -> Single<VAResponse> in
                return responseBy(messageId)
            }
    }
}
