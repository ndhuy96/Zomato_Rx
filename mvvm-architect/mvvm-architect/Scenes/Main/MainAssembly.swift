//
//  MainAssembly.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy B on 6/23/20.
//  Copyright © 2020 sun. All rights reserved.
//

// swiftlint:disable force_unwrapping
// swiftlint:disable line_length

final class MainAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MainViewModel.self) { (_, c: MainViewController, restaurantsRepository: RestaurantsRepository) in
            let mainNavigator = MainNavigator(c.navigationController!,
                                              restaurantsRepository: restaurantsRepository)
            let mainUseCase = MainUseCase(repository: restaurantsRepository)
            return MainViewModel(dependencies: MainViewModel.Dependencies(navigator: mainNavigator,
                                                                          useCase: mainUseCase))
        }
    }
}
