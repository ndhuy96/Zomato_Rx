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

final class MainNavigator: MainNavigatable {
    private let navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigateToDetailScreen(with resId: String) {
        guard let vc = R.storyboard.main.detailViewController() else { return }
        let assembler = Assembler([DetailAssembler()],
                                  container: SwinjectStoryboard.defaultContainer)
        guard let vm = assembler.resolver.resolve(DetailViewModel.self, argument: resId) else { return }
        vc.bindViewModel(to: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
