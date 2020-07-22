//
//  MainNavigator.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/21/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol MainNavigatable {
    func navigateToDetailScreen(with resId: String)
}

struct MainNavigator: MainNavigatable {
    private unowned var navigationController: UINavigationController
    private var restaurantsRepository: RestaurantsRepository

    init(_ navigationController: UINavigationController, restaurantsRepository: RestaurantsRepository) {
        self.navigationController = navigationController
        self.restaurantsRepository = restaurantsRepository
    }

    func navigateToDetailScreen(with resId: String) {
        guard let vc = R.storyboard.main.detailViewController() else { return }
        let assembler = Assembler([DetailAssembler()])
        guard let vm = assembler.resolver.resolve(DetailViewModel.self,
                                                  arguments: resId,
                                                  restaurantsRepository) else { return }
        vc.bindViewModel(to: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
