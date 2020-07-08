//
//  SwinjectStoryboard+Setup.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

// swiftlint:disable force_unwrapping
extension SwinjectStoryboard {
    @objc
    class func setup() {
        Container.loggingFunction = nil

        defaultContainer.register(APIService.self) { _ in
            APIServiceImpl()
        }
        .inObjectScope(.container)

        defaultContainer.register(RestaurantsRepository.self) { r in
            let api = r.resolve(APIService.self)!
            return RestaurantsRepositoryImpl(api)
        }
        .inObjectScope(.container)

        defaultContainer.storyboardInitCompleted(HomeViewController.self) { _, c in
            let assembler = Assembler([HomeAssembler()],
                                      container: defaultContainer)
            guard let vm = assembler.resolver.resolve(HomeViewModel.self,
                                                      argument: c) else { return }
            c.bindViewModel(to: vm)
        }

        defaultContainer.storyboardInitCompleted(DiningViewController.self) { _, _ in
//            c.api = r.resolve(RestaurantsRepository.self)
        }
    }
}
