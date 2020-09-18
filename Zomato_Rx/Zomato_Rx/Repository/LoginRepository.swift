//
//  LoginRepository.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/13/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

protocol LoginRepository {
    func loginFacebook(_ vc: UIViewController) -> Single<AccessToken>
    func loginGoogle() -> Single<GIDAuthentication>
    func loginFirebase(email: String, password: String) -> Single<AuthResult>
    func signIntoFirebase(_ credential: AuthCredential) -> Single<AuthResult>
}

final class LoginRepositoryImpl: LoginRepository {
    func loginFacebook(_ vc: UIViewController) -> Single<AccessToken> {
        let loginManager = LoginManager()
        return loginManager.rx.login(with: [.publicProfile, .email], vc: vc)
    }

    func loginGoogle() -> Single<GIDAuthentication> {
        let disposeBag = DisposeBag()

        return Single<GIDAuthentication>.create { singleEvent in
            GIDSignIn.sharedInstance().rx.signIn
                .subscribe(onNext: { user in
                    singleEvent(.success(user.authentication))
                }, onError: { err in
                    Log.debug(message: "Failed to login Google with error: \(err.localizedDescription)")
                    singleEvent(.error(AuthError.cancelled))
                })
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }

    func loginFirebase(email: String, password: String) -> Single<AuthResult> {
        return Single<AuthResult>.create { singleEvent in
            Auth.auth().signIn(withEmail: email, password: password) { _, err in
                if let err = err {
                    Log.debug(message: "Login to Firebase error: \(err.localizedDescription)")
                    singleEvent(.error(err))
                    return
                }
                Log.debug(message: "Login to Firebase successfully")
                singleEvent(.success(.success))
            }
            return Disposables.create()
        }
    }

    func signIntoFirebase(_ credential: AuthCredential) -> Single<AuthResult> {
        return Single<AuthResult>.create { singleEvent in
            Auth.auth().signIn(with: credential) { _, err in
                if let err = err {
                    Log.debug(message: "Sign in error: \(err.localizedDescription)")
                    singleEvent(.error(AuthError.cannotLogin))
                    return
                }
                Log.debug(message: "successfully authenticated with Firebase")
                singleEvent(.success(.success))
            }
            return Disposables.create()
        }
    }
}
