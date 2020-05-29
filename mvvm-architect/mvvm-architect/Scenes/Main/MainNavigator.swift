//
//  MainNavigator.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/21/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol MainNavigatable {
    func navigateToDetailScreen(with resId: String, api: RestaurantsRepository)
}

final class MainNavigator: MainNavigatable {
    private let navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigateToDetailScreen(with resId: String, api: RestaurantsRepository) {
        let restaurantDetailVM = DetailViewModel(dependencies: DetailViewModel.Dependencies(id: resId,
                                                                                            api: api))
        guard let vc = R.storyboard.main.detailViewController() else { return }
        vc.viewModel = restaurantDetailVM
        navigationController.pushViewController(vc, animated: true)
    }
}
