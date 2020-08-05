//
//  RegisterRepository.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 8/4/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import Firebase

protocol RegisterRepository {
    func registerToFirebase(email: String, password: String) -> Single<AuthDataResult>
    func createUserProfile(user: AuthDataResult, with userName: String) -> Single<AuthResult>
}

final class RegisterRepositoryImpl: RegisterRepository {
    func registerToFirebase(email: String, password: String) -> Single<AuthDataResult> {
        return Single<AuthDataResult>.create { singleEvent in
            Auth.auth().createUser(withEmail: email, password: password) { data, error in
                if let err = error {
                    Log.debug(message: "Sign up error: \(err.localizedDescription)")
                    singleEvent(.error(AuthError.cannotRegister))
                    return
                }

                guard let data = data else {
                    return
                }
                Log.debug(message: "Sign up with Firebase successfully")
                singleEvent(.success(data))
            }
            return Disposables.create()
        }
    }

    func createUserProfile(user: AuthDataResult, with userName: String) -> Single<AuthResult> {
        return Single<AuthResult>.create { singleEvent in
            let request = user.user.createProfileChangeRequest()
            request.displayName = userName
            request.commitChanges { error in
                if let err = error {
                    Log.debug(message: "Create user profile unsuccessfully with error: \(err.localizedDescription)")
                    singleEvent(.error(AuthError.cancelled))
                } else {
                    Log.debug(message: "Create user profile successfully")
                    singleEvent(.success(.success))
                }
            }
            return Disposables.create()
        }
    }
}
