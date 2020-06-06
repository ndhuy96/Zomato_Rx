//
//  APIService.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import Alamofire

protocol APIService {
    func request<T: Decodable>(router: APIRouter) -> Single<T>
}

final class APIServiceImpl: APIService {
    private var alamoFireManager = Session.default

    func request<T: Decodable>(router: APIRouter) -> Single<T> {
        if !Reachability.isConnectedToNetwork() {
            return Single.error(APIError.networkError)
        }
        Log.debug(message: "🌎 \(router.method.rawValue) \(router.url)")
        return Single<T>.create { singleEvent in
            let request = AF.request(router)
                .responseJSON { [weak self] response in
                    self?.processResponse(response, singleEvent)
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }

    private func processResponse<T: Decodable>(_ response: AFDataResponse<Any>,
                                               _ singleEvent: @escaping (SingleEvent<T>) -> Void) {
        switch response.result {
        case .success:
            guard let code = response.response?.statusCode,
                let statusCode = HttpStatusCode(rawValue: code) else {
                singleEvent(.error(APIError.unexpectedError))
                return
            }

            switch statusCode.responseType {
            case .success:
                do {
                    guard let responseData = response.data else { return }
                    Log.debug(message: "👍 [\(code)] " + (response.request?.url?.absoluteString ?? ""))
                    Log.debug(message: "RESPONSE FROM SERVER: \(response.result)")
                    let object = try JSONDecoder().decode(T.self, from: responseData)
                    singleEvent(.success(object))
                } catch {
                    Log.debug(message: "❌ \(error.localizedDescription)")
                    singleEvent(.error(APIError.apiFailure))
                }
            default:
                Log.debug(message: "❌ [\(code)] " + (response.request?.url?.absoluteString ?? ""))
                singleEvent(.error(APIError.httpError(httpCode: statusCode)))
            }
        case let .failure(error):
            singleEvent(.error(error))
        }
    }
}
