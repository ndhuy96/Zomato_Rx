//
//  BaseError.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/19/20.
//  Copyright © 2020 sun. All rights reserved.
//

enum ErrorMessage: String {
    case networkError = "The internet got lost. Please try again!"
    case unexpectedError = "The system has an unexpected error. Please try again!"
    case apiFailure = "The API Request has failure. Please try again!"
}

enum BaseError: Error {
    case networkError
    case httpError(httpCode: Int)
    case unexpectedError
    case apiFailure

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

    private func getHttpErrorMessage(httpCode: Int) -> String? {
        if httpCode >= 300, httpCode <= 308 {
            // Redirection
            return "It was transferred to a different URL. I'm sorry for causing you trouble"
        } else if httpCode >= 400, httpCode <= 451 {
            // Client Error
            return "An error occurred on the application side. Please try again later!"
        } else if httpCode >= 500, httpCode <= 511 {
            // Server error
            return "A server error occurred. Please try again later!"
        } else {
            // Unofficial error
            return "An error occurred. Please try again later!"
        }
    }
}
