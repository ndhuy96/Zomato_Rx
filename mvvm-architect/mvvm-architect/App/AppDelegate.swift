//
//  AppDelegate.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/14/20.
//  Copyright © 2020 sun. All rights reserved.
//

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // App services
    var services: [UIApplicationDelegate] = [GoogleMapService()]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        for service in services {
            _ = service.application?(application, didFinishLaunchingWithOptions: launchOptions)
        }

        return true
    }
}
