//
//  HomeViewModel.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/18/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

struct HomeViewModel: ViewModelType {
    struct Input {
        let skipTrigger: Driver<Void>
        let continueWithEmailTrigger: Driver<Void>
        let loginWithFBTrigger: Driver<Void>
        let loginWithGgTrigger: Driver<Void>
    }

    struct Output {
        let banners: Driver<[String]>
        let skip: Driver<Void>
        let continueWithEmail: Driver<Void>
        let loginWithFB: Driver<Void>
        let loginWithGg: Driver<Void>
        let loading: Driver<Bool>
        let error: Driver<Error>
    }

    struct Dependencies {
        let useCase: HomeUseCaseType
        let navigator: HomeNavigatable
    }

    private let dependencies: Dependencies
    private let kNumberOfBanners: Int = 6

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func transform(input: Input) -> Output {
        // Initial Data
        var bannerItems: [String] = []
        for n in 1 ... kNumberOfBanners {
            bannerItems.append("login_scroller_\(n)_Normal")
        }

        let banners = Observable.just(bannerItems)
            .asDriver(onErrorJustReturn: [])

        let skip = input.skipTrigger
            .do(onNext: {
                self.dependencies.navigator.navigateToTabBarScreen()
            })

        let continueWithEmail = input.continueWithEmailTrigger
            .do(onNext: {
                self.dependencies.navigator.navigateToRegisterScreen()
            })

        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let loginWithFB = input.loginWithFBTrigger
            .flatMapLatest { _ -> Driver<AccessToken> in
                self.dependencies.useCase.loginFacebook()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .flatMapLatest { token -> Driver<AuthResult> in
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                return self.dependencies.useCase.signIntoFirebase(credential)
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

        let loginWithGg = input.loginWithGgTrigger
            .flatMapLatest { _ -> Driver<GIDAuthentication> in
                self.dependencies.useCase.loginGoogle()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .flatMapLatest { auth -> Driver<AuthResult> in
                let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken,
                                                               accessToken: auth.accessToken)
                return self.dependencies.useCase.signIntoFirebase(credential)
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

        return Output(banners: banners,
                      skip: skip,
                      continueWithEmail: continueWithEmail,
                      loginWithFB: loginWithFB,
                      loginWithGg: loginWithGg,
                      loading: loading,
                      error: errors)
    }
}
