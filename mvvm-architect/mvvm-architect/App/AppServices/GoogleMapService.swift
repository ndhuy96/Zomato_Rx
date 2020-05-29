//
//  GoogleMapService.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/19/20.
//  Copyright © 2020 sun. All rights reserved.
//

import GoogleMaps

final class GoogleMapService: NSObject, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        GMSServices.provideAPIKey(APIKey.googleApiKey)
        return true
    }
}
