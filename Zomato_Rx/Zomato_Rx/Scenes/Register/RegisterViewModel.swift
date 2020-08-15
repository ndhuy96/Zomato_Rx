//
//  RegisterViewModel.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 8/4/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import Firebase

struct RegisterViewModel: ViewModelType {
    struct Input {
        let username: Driver<String>
        let email: Driver<String>
        let password: Driver<String>
        let registerTrigger: Driver<Void>
        let continueWithLoginTrigger: Driver<Void>
        let backTrigger: Driver<Void>
    }

    struct Output {
        let register: Driver<Void>
        let continueWithLogin: Driver<Void>
        let back: Driver<Void>
        let loading: Driver<Bool>
        let error: Driver<Error>
    }

    struct Dependencies {
        let useCase: RegisterUseCaseType
        let navigator: RegisterNavigatable
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func transform(input: RegisterViewModel.Input) -> RegisterViewModel.Output {
        let back = input.backTrigger
            .do(onNext: {
                self.dependencies.navigator.goBack()
            })

        let continueWithLogin = input.continueWithLoginTrigger
            .do(onNext: {
                self.dependencies.navigator.navigateToLoginScreen()
            })

        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let emailAndPassword = Driver.combineLatest(input.email, input.password) { ($0, $1) }
        let validUserName = input.username
            .map { $0.trimmingCharacters(in: .whitespaces) }

        let register = input.registerTrigger
            .withLatestFrom(emailAndPassword)
            .flatMapLatest { pair -> Driver<(AuthDataResult, String)> in
                let (email, password) = pair
                let accountInfo = self.dependencies.useCase.register(email: email, password: password)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                return Driver.combineLatest(accountInfo, validUserName) { ($0, $1) }
            }
            .flatMapLatest { userInfo -> Driver<AuthResult> in
                let (userData, userName) = userInfo
                return self.dependencies.useCase.createProfile(user: userData,
                                                               with: userName)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .filter { $0 == .success }
            .do(onNext: { _ in
                UserDefaultsManager.shared.set(.loggedIn, value: true)
                self.dependencies.navigator.navigateToTabBarScreen()
            })
            .mapToVoid()

        let loading = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()

        return Output(register: register,
                      continueWithLogin: continueWithLogin,
                      back: back,
                      loading: loading,
                      error: errors)
    }
}
