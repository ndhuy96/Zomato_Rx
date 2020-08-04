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

struct HomeNavigator: HomeNavigatable {
    unowned var navigationController: UINavigationController

    func navigateToTabBarScreen() {
        App.shared.moveToTabBarScreen()
    }

    func navigateToRegisterScreen() {
        guard let vc = R.storyboard.register.registerNavigationController() else { return }
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true, completion: nil)
    }
}
