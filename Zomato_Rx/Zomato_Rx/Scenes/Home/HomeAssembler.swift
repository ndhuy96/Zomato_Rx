//
//  HomeAssembler.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/9/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

// swiftlint:disable force_unwrapping
final class HomeAssembler: Assembly {
    func assemble(container: Container) {
        container.register(HomeNavigatable.self) { _, navigationController in
            HomeNavigator(navigationController)
        }

        container.register(HomeViewModel.self) { (r, c: HomeViewController) in
            HomeViewModel(dependencies:
                HomeViewModel.Dependencies(navigator: r.resolve(HomeNavigatable.self,
                                                                argument: c.navigationController!)!))
        }
    }
}
