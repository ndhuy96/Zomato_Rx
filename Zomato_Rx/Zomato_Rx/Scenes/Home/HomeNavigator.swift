//
//  HomeNavigator.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/18/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

protocol HomeNavigatable {
    func navigateToTabBarScreen()
    func navigateToRegisterScreen()
}

final class HomeNavigator: HomeNavigatable {
    private let navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigateToTabBarScreen() {
        App.shared.moveToTabBarScreen()
    }

    func navigateToRegisterScreen() {
        guard let vc = R.storyboard.register.registerViewController() else { return }
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true, completion: nil)
    }
}
