//
//  BaseClient.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 01/06/2022.
//

import RxSwift
import Alamofire
import Foundation

class BaseClient {
    let sessionManager: Session
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Session.default.sessionConfiguration.httpAdditionalHeaders
        configuration.timeoutIntervalForRequest = 20
        sessionManager = Session(configuration: configuration, interceptor: EnvironmentInterceptor())
    }
    
    func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Single<T> {
        Log.debug(message: "\(String(describing: urlConvertible.urlRequest))", mode: .debug)
        return Single<T>.create { single in
            let request = self.sessionManager
                .request(urlConvertible)
                .validate()
                .responseDecodable {
                    (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let value):
                    single(.success(value))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}


class EnvironmentInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        //        var urlRequest = urlRequest
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        switch statusCode {
        case 200...299:
            completion(.doNotRetry)
        case 401:
            refreshToken { (error) in
                completion(.retry)
            }
        default:
            completion(.doNotRetry)
            break
        }
    }
    
    func refreshToken(completion: @escaping (Error?) -> Void) {
        guard let appToken = NetworkAdapter.shared.appToken else {
            completion(AFError.NetworkError.tokenNotValid)
            return
        }
        let params: [String: Any] = [
            "refresh_token": appToken.refreshToken
        ]
        let urlConvert = AssistantRouter.refreshToken(VAagentId: NetworkAdapter.shared.VAagentId, deviceId: appToken.deviceID, params: params)
        AF.request(urlConvert).responseDecodable { (response: AFDataResponse<AppToken>) in
            switch response.result {
            case .success(let value):
                NetworkAdapter.shared.appToken = value
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}

fileprivate extension AFError {
    enum NetworkError: Error {
        case tokenNotValid
    }
}
