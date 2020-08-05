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

        defaultContainer.register(LoginRepository.self) { _ in
            LoginRepositoryImpl()
        }
        .inObjectScope(.container)

        defaultContainer.register(RegisterRepository.self) { _ in
            RegisterRepositoryImpl()
        }
        .inObjectScope(.container)

        defaultContainer.storyboardInitCompleted(HomeViewController.self) { r, c in
            let assembler = Assembler([HomeAssembly()])
            let loginRepository = r.resolve(LoginRepository.self)!
            guard let vm = assembler.resolver.resolve(HomeViewModel.self,
                                                      arguments: c,
                                                      loginRepository) else { return }
            c.bindViewModel(to: vm)
        }

        defaultContainer.storyboardInitCompleted(RegisterViewController.self) { r, c in
            let assembler = Assembler([RegisterAssembly()])
            let registerRepository = r.resolve(RegisterRepository.self)!
            guard let vm = assembler.resolver.resolve(RegisterViewModel.self,
                                                      arguments: c,
                                                      registerRepository) else { return }
            c.bindViewModel(to: vm)
        }
    }
}
