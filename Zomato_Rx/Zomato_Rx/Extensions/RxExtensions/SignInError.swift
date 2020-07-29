//
//  SignInError.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/22/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

enum SignInResult {
    case success
    case failure
}

enum SignInError: Error {
    case tokenNotFound
    case cancelled
}

extension SignInError {
    var message: String {
        switch self {
        case .tokenNotFound:
            return "The operation couldn’t be completed because token was not found."
        case .cancelled:
            return "The operation was cancelled."
        }
    }
}
