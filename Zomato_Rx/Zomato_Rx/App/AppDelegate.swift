//
//  AppDelegate.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy B on 5/29/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import FBSDKCoreKit
import Firebase
import GoogleSignIn

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            App.shared.window = window
            App.shared.startInterface()
        }

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let facebookDidHandle = ApplicationDelegate.shared
            .application(app,
                         open: url,
                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                         annotation: options[UIApplication.OpenURLOptionsKey.annotation])

        let googleDidHandle = GIDSignIn.sharedInstance().handle(url)
        return facebookDidHandle || googleDidHandle
    }
}
