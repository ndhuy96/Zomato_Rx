//
//  LoginViewModel.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 8/15/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

struct LoginViewModel: ViewModelType {
    struct Input {
        let email: Driver<String>
        let password: Driver<String>
        let loginTrigger: Driver<Void>
        let continueWithSignUpTrigger: Driver<Void>
    }

    struct Output {
        let login: Driver<Void>
        let continueWithSignUp: Driver<Void>
        let loading: Driver<Bool>
        let error: Driver<Error>
    }

    struct Dependencies {
        let useCase: LoginUseCaseType
        let navigator: LoginNavigatable
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func transform(input: LoginViewModel.Input) -> LoginViewModel.Output {
        let continueWithSignUp = input.continueWithSignUpTrigger
            .do(onNext: {
                self.dependencies.navigator.goBack()
            })

        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let emailAndPassword = Driver.combineLatest(input.email, input.password) { ($0, $1) }

        let login = input.loginTrigger
            .withLatestFrom(emailAndPassword)
            .flatMapLatest { pair -> Driver<AuthResult> in
                let (email, password) = pair
                return self.dependencies.useCase.loginWithFirebase(email: email, password: password)
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

        return Output(login: login,
                      continueWithSignUp: continueWithSignUp,
                      loading: loading,
                      error: errors)
    }
}
