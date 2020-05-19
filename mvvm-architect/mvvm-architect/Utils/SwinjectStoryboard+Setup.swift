//
//  SwinjectStoryboard+Setup.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy B on 5/4/20.
//  Copyright © 2020 sun. All rights reserved.
//

extension SwinjectStoryboard {
    @objc
    class func setup() {
        Container.loggingFunction = nil

        defaultContainer.register(APIService.self) { _ in
            APIServiceImpl()
        }
        .inObjectScope(.container)

        // swiftlint:disable force_unwrapping
        defaultContainer.register(RestaurantsRepository.self) { r in
            let api = r.resolve(APIService.self)!
            return RestaurantsRepositoryImpl(api)
        }
        .inObjectScope(.container)

        defaultContainer.storyboardInitCompleted(MainViewController.self) { r, c in
            c.api = r.resolve(RestaurantsRepository.self)
            c.count = kDefaultRequestItemNumber
        }
    }
}
