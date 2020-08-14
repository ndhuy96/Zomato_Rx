//
//  HomeUseCase.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/13/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import FBSDKCoreKit
import Firebase
import GoogleSignIn

protocol HomeUseCaseType {
    func loginFacebook() -> Single<AccessToken>
    func loginGoogle() -> Single<GIDAuthentication>
    func signIntoFirebase(_ credential: AuthCredential) -> Single<AuthResult>
}

struct HomeUseCase: HomeUseCaseType {
    var repository: LoginRepository
    unowned var vc: HomeViewController

    func loginFacebook() -> Single<AccessToken> {
        return repository.loginFacebook(vc)
    }

    func loginGoogle() -> Single<GIDAuthentication> {
        return repository.loginGoogle()
    }

    func signIntoFirebase(_ credential: AuthCredential) -> Single<AuthResult> {
        return repository.signIntoFirebase(credential)
    }
}
