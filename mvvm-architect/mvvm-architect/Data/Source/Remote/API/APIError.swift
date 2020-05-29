//
//  APIError.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/19/20.
//  Copyright © 2020 sun. All rights reserved.
//

enum ErrorMessage: String {
    case networkError = "The internet got lost. Please try again!"
    case unauthorized = "Unauthorized - You are not authorized to this action"
    case unexpectedError = "The system has an unexpected error. Please try again!"
    case apiFailure = "The API Request has failure. Please try again!"
    case redirection = "It was transferred to a different URL. I'm sorry for causing you trouble"
    case clientError = "An error occurred on the application side. Please try again later!"
    case serverError = "A server error occurred. Please try again later!"
    case unofficialError = "An error occurred. Please try again later!"
}

enum APIError: Error {
    case networkError
    case unauthorized
    case httpError(httpCode: HttpStatusCode)
    case apiFailure
    case unexpectedError
}

extension APIError {
    var errorMessage: String? {
        switch self {
        case .networkError:
            return ErrorMessage.networkError.rawValue
        case let .httpError(code):
            return getHttpErrorMessage(httpCode: code)
        case .apiFailure:
            return ErrorMessage.apiFailure.rawValue
        default:
            return ErrorMessage.unexpectedError.rawValue
        }
    }

    private func getHttpErrorMessage(httpCode: HttpStatusCode) -> String? {
        switch httpCode.responseType {
        case .redirection:
            return ErrorMessage.redirection.rawValue
        case .clientError:
            return ErrorMessage.clientError.rawValue
        case .serverError:
            return ErrorMessage.serverError.rawValue
        default:
            return ErrorMessage.unofficialError.rawValue
        }
    }
}

enum HttpStatusCode: Int {
    enum ResponseType {
        case informational
        case success
        case redirection
        case clientError
        case serverError
        case undefined
    }

    // Informational - 1xx
    case `continue` = 100
    case switchingProtocols = 101
    case processing = 102

    // Success - 2xx
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206
    case multiStatus = 207
    case alreadyReported = 208
    case IMUsed = 226

    // Redirection - 3xx
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case switchProxy = 306
    case temporaryRedirect = 307
    case permenantRedirect = 308

    // Client Error - 4xx
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case URITooLong = 414
    case unsupportedMediaType = 415
    case rangeNotSatisfiable = 416
    case expectationFailed = 417
    case teapot = 418
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case noResponse = 444
    case unavailableForLegalReasons = 451
    case SSLCertificateError = 495
    case SSLCertificateRequired = 496
    case HTTPRequestSentToHTTPSPort = 497
    case clientClosedRequest = 499

    // Server Error - 5xx
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case HTTPVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case notExtended = 510
    case networkAuthenticationRequired = 511

    var responseType: ResponseType {
        switch rawValue {
        case 100 ..< 200:
            return .informational
        case 200 ..< 300:
            return .success
        case 300 ..< 400:
            return .redirection
        case 400 ..< 500:
            return .clientError
        case 500 ..< 600:
            return .serverError
        default:
            return .undefined
        }
    }
}
