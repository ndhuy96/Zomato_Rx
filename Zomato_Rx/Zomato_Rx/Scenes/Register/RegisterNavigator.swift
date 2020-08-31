//
//  RegisterNavigator.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 8/4/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

protocol RegisterNavigatable {
    func goBack()
    func navigateToTabBarScreen()
    func navigateToLoginScreen()
}

struct RegisterNavigator: RegisterNavigatable {
    unowned var navigationController: UINavigationController
    var loginRepository: LoginRepository

    func goBack() {
        navigationController.dismiss(animated: true)
    }

    func navigateToTabBarScreen() {
        App.shared.moveToTabBarScreen()
    }

    func navigateToLoginScreen() {
        guard let vc = R.storyboard.login.loginViewController() else { return }
        let assembler = Assembler([LoginAssembly()])

        guard let vm = assembler.resolver.resolve(LoginViewModel.self,
                                                  arguments: loginRepository,
                                                  navigationController) else { return }
        vc.bindViewModel(to: vm)

        navigationController.pushViewController(vc, animated: true)
    }
}
