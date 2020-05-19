//
//  APIRouter.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy B on 5/6/20.
//  Copyright © 2020 sun. All rights reserved.
//

import Alamofire
let kDefaultRequestItemNumber: Int = 20
enum Environment {
    case dev
//    case staging
//    case production

    var apiUrl: String {
        switch self {
        case .dev:
            return "https://developers.zomato.com/api"
        }
    }

    var version: String {
        return "/v2.1"
    }

    var baseUrl: String {
        return "\(apiUrl)\(version)"
    }
}

enum APIRouter: URLRequestConvertible {
    case fetchCategories
    case search(start: Int, count: Int = kDefaultRequestItemNumber)
    case fetchResDetail(resId: String)

    static let baseURL = Environment.dev.baseUrl

    var method: HTTPMethod {
        switch self {
        case .fetchCategories, .search, .fetchResDetail:
            return .get
        }
    }

    var path: String {
        switch self {
        case .fetchCategories:
            return "/categories"
        case .search:
            return "/search"
        case .fetchResDetail:
            return "/restaurant"
        }
    }

    var url: String {
        return "\(APIRouter.baseURL)\(path)"
    }

    var encoding: ParameterEncoding {
        switch self {
        case .fetchCategories, .search, .fetchResDetail:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}

extension APIRouter {
    func asURLRequest() throws -> URLRequest {
        let url = try APIRouter.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.timeoutInterval = Constants.Network.timeout
        urlRequest.headers = HTTPHeaders.default
        urlRequest.setValue(APIKey.apiKey, forHTTPHeaderField: "user-key")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        // For GET, HEAD, and DELETE requests, URLEncoding.default encodes the parameters as a query string and adds it to the URL
        // For any other method (such as POST), JSONEncoding.default encodes the parameters as a query string and sent as the body of the HTTP request.

        switch self {
        case let .search(start, count):
            let params = [
                "start": start,
                "count": count,
            ]
            urlRequest = try encoding.encode(urlRequest, with: params)
        case let .fetchResDetail(resId):
            let params = [
                "res_id": resId,
            ]
            urlRequest = try encoding.encode(urlRequest, with: params)
        default:
            break
        }

        return urlRequest
    }
}
