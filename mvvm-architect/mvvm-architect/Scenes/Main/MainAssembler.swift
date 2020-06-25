//
//  MainAssembler.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy B on 6/23/20.
//  Copyright © 2020 sun. All rights reserved.
//

// swiftlint:disable force_unwrapping

final class MainAssembler: Assembly {
    func assemble(container: Container) {
        container.register(MainUseCaseType.self) { r in
            MainUseCase(repository: r.resolve(RestaurantsRepository.self)!)
        }

        container.register(MainNavigatable.self) { _, navigationController in
            MainNavigator(navigationController)
        }

        container.register(MainViewModel.self) { (r, c: MainViewController) in
            MainViewModel(dependencies:
                MainViewModel.Dependencies(navigator: r.resolve(MainNavigatable.self,
                                                                argument: c.navigationController!)!,
                                           useCase: r.resolve(MainUseCaseType.self)!))
        }
    }
}
