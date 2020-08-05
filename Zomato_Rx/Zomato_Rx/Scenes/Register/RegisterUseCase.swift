//
//  RegisterUseCase.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 8/4/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import Firebase

protocol RegisterUseCaseType {
    func register(email: String, password: String) -> Single<AuthDataResult>
    func createProfile(user: AuthDataResult, with userName: String) -> Single<AuthResult>
}

struct RegisterUseCase: RegisterUseCaseType {
    var repository: RegisterRepository

    func register(email: String, password: String) -> Single<AuthDataResult> {
        return repository.registerToFirebase(email: email, password: password)
    }

    func createProfile(user: AuthDataResult, with userName: String) -> Single<AuthResult> {
        return repository.createUserProfile(user: user, with: userName)
    }
}
