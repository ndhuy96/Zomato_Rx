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

let kNumberOfBanners: Int = 6

struct HomeViewModel: ViewModelType {
    struct Input {
        let skipTrigger: Driver<Void>
        let registerTrigger: Driver<Void>
        let loginWithFBTrigger: Driver<UIViewController>
        let loginWithGgTrigger: Driver<Void>
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
                        print("Successfully logged in into Facebook")
                        self.signIntoFirebase(token)
                    case let .failed(err):
                        let errorMessage = "Failed to get Facebook user with error: \(err.localizedDescription)"
                        SVProgressHUD.showError(withStatus: errorMessage)
                    case .cancelled:
                        print("Cancelled getting Facebook user")
                        SVProgressHUD.dismiss(withDelay: 0.3)
                    }
                }
            })
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let loginWithGg = input.loginWithGgTrigger
            .do(onNext: {})

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
                print("Sign up error: \(err.localizedDescription)")
                SVProgressHUD.showError(withStatus: "Sign up error: \(err.localizedDescription)")
                return
            }
            print("successfully authenticated with Firebase")
            SVProgressHUD.showSuccess(withStatus: "Login successfully")
        }
    }
}
