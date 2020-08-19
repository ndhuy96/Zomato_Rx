//
//  LoginUseCase.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 8/15/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

protocol LoginUseCaseType {
    func loginWithFirebase(email: String, password: String) -> Single<AuthResult>
}

struct LoginUseCase: LoginUseCaseType {
    var repository: LoginRepository

    func loginWithFirebase(email: String, password: String) -> Single<AuthResult> {
        return repository.loginFirebase(email: email, password: password)
    }
}
