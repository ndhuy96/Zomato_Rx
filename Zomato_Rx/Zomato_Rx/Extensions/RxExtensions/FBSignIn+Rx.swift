//
//  FBSignIn+Rx.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

extension Reactive where Base: LoginManager {
    func login(with permissions: [Permission], vc: UIViewController? = nil) -> Single<AccessToken> {
        return Single<AccessToken>.create { singleEvent in
            self.base.logIn(permissions: permissions, viewController: vc) { result in
                switch result {
                case .success(granted: _, declined: _, let token):
                    Log.debug(message: "Successfully logged in into Facebook")
                    singleEvent(.success(token))
                case let .failed(err):
                    Log.debug(message: "Failed to login Facebook with error: \(err.localizedDescription)")
                    singleEvent(.error(SignInError.tokenNotFound))
                case .cancelled:
                    singleEvent(.error(SignInError.cancelled))
                }
            }

            return Disposables.create()
        }
    }
}
