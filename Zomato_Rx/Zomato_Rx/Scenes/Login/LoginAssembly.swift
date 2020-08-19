//
//  LoginAssembly.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 8/15/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

final class LoginAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoginViewModel.self) {
            (_, loginRepository: LoginRepository, navigationController: UINavigationController) in
            let loginNavigator = LoginNavigator(navigationController: navigationController)
            let loginUseCase = LoginUseCase(repository: loginRepository)
            return LoginViewModel(dependencies: LoginViewModel.Dependencies(useCase: loginUseCase,
                                                                            navigator: loginNavigator))
        }
    }
}
