//
//  UserDefaultsManager.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/11/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let manager = UserDefaults.standard

    enum UserDefaultsKey: String {
        case loggedIn = "LOGGED_IN"
    }

    private init() {}

    private func registerDefault(_ key: UserDefaultsKey, value: Bool) {
        manager.register(defaults: [key.rawValue: value])
    }

    func get(_ key: UserDefaultsKey) -> Bool {
        return manager.bool(forKey: key.rawValue)
    }

    func set(_ key: UserDefaultsKey, value: Bool) {
        manager.set(value, forKey: key.rawValue)
    }
}
