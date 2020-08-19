//
//  LoginNavigator.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 8/15/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

protocol LoginNavigatable {
    func goBack()
    func navigateToTabBarScreen()
}

struct LoginNavigator: LoginNavigatable {
    unowned var navigationController: UINavigationController

    func goBack() {
        navigationController.popViewController(animated: true)
    }

    func navigateToTabBarScreen() {
        App.shared.moveToTabBarScreen()
    }
}
