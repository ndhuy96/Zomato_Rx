//
//  APIService.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/20/20.
//  Copyright © 2020 sun. All rights reserved.
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
        Log.debug(message: "API url: \(router.url)")
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
                    Log.debug(message: "RESPONSE FROM SERVER: \(response.result)")
                    let object = try JSONDecoder().decode(T.self, from: responseData)
                    singleEvent(.success(object))
                } catch {
                    singleEvent(.error(APIError.apiFailure))
                }
            default:
                singleEvent(.error(APIError.httpError(httpCode: statusCode)))
            }
        case let .failure(error):
            singleEvent(.error(error))
        }
    }
}
