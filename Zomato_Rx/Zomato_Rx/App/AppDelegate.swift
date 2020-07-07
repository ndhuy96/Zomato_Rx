//
//  AppDelegate.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy B on 5/29/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // App services
    var services: [UIApplicationDelegate] = [AuthenticationService()]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        for service in services {
            _ = service.application?(application, didFinishLaunchingWithOptions: launchOptions)
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        for service in services {
            guard let service = service.application?(app, open: url, options: options) else {
                return false
            }
            return service
        }
        return false
    }
}
