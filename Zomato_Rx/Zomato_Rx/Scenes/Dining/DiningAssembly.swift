//
//  DiningAssembly.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 9/22/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

// swiftlint:disable force_unwrapping
// swiftlint:disable line_length

final class DiningAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DiningViewModel.self) { (_, c: DiningViewController, restaurantsRepository: RestaurantsRepository) in
            let diningNavigator = DiningNavigator(c.navigationController!)
            let diningUseCase = DiningUseCase(repository: restaurantsRepository)
            return DiningViewModel(dependencies: DiningViewModel.Dependencies(navigator: diningNavigator,
                                                                              useCase: diningUseCase))
        }
    }
}
