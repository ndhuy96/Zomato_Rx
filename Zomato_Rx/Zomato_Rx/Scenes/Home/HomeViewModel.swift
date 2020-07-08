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
        let registerTrigger: Driver<Void>
        let loginWithFBTrigger: Driver<UIViewController>
        let loginWithGgTrigger: Driver<UIViewController>
    }

    struct Output {
        let banners: Driver<[String]>
        let skip: Driver<Void>
        let register: Driver<Void>
        let loginWithFB: Driver<Void>
        let loginWithGg: Driver<Void>
    }

    struct Dependencies {
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

        let register = input.registerTrigger
            .do(onNext: {
                self.dependencies.navigator.navigateToRegisterScreen()
            })

        let loginWithFB = input.loginWithFBTrigger.asObservable()
            .do(onNext: { vc in
                SVProgressHUD.show()
                let loginManager = LoginManager()
                loginManager.logIn(permissions: [.publicProfile, .email], viewController: vc) { result in
                    switch result {
                    case .success(granted: _, declined: _, let token):
                        Log.debug(message: "Successfully logged in into Facebook")
                        self.signIntoFirebase(token)
                    case let .failed(err):
                        let errorMessage = "Failed to get Facebook user with error: \(err.localizedDescription)"
                        Log.debug(message: errorMessage)
//                        SVProgressHUD.showError(withStatus: errorMessage)
                    case .cancelled:
                        Log.debug(message: "Cancelled getting Facebook user")
                        SVProgressHUD.dismiss(withDelay: 0.3)
                    }
                }
            })
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let loginWithGg = input.loginWithGgTrigger.asObservable()
            .do(onNext: { vc in
                UserDefaultsManager.shared.set(.loggedIn, value: true)
                GIDSignIn.sharedInstance()?.presentingViewController = vc
                GIDSignIn.sharedInstance().signIn()
            })
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        return Output(banners: banners,
                      skip: skip,
                      register: register,
                      loginWithFB: loginWithFB,
                      loginWithGg: loginWithGg)
    }

    fileprivate func signIntoFirebase(_ token: AccessToken) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        Auth.auth().signIn(with: credential) { _, err in
            if let err = err {
                Log.debug(message: "Sign up error: \(err.localizedDescription)")
//                SVProgressHUD.showError(withStatus: "Sign up error: \(err.localizedDescription)")
                return
            }
            Log.debug(message: "successfully authenticated with Firebase")
            UserDefaultsManager.shared.set(.loggedIn, value: true)
            self.dependencies.navigator.navigateToTabBarScreen()
        }
    }
}
