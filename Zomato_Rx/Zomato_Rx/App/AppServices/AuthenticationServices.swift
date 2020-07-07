//
//  AuthenticationServices.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/21/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import FBSDKCoreKit
import Firebase

// swiftlint:disable line_length
final class AuthenticationService: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app,
                                               open: url,
                                               sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                               annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
}
