//
//  HomeAssembly.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/9/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

// swiftlint:disable force_unwrapping

final class HomeAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewModel.self) { (_, c: HomeViewController, loginRepository: LoginRepository) in
            let homeNavigator = HomeNavigator(navigationController: c.navigationController!)
            let homeUseCase = HomeUseCase(repository: loginRepository, vc: c)
            return HomeViewModel(dependencies: HomeViewModel.Dependencies(useCase: homeUseCase,
                                                                          navigator: homeNavigator))
        }
    }
}
