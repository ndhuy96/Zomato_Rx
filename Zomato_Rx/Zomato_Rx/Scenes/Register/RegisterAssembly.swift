//
//  RegisterAssembly.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 8/4/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

// swiftlint:disable force_unwrapping

final class RegisterAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RegisterViewModel.self) {
            (_, c: RegisterViewController, registerRepository: RegisterRepository) in
            let registerNavigator = RegisterNavigator(navigationController: c.navigationController!)
            let registerUseCase = RegisterUseCase(repository: registerRepository)
            return RegisterViewModel(dependencies: RegisterViewModel.Dependencies(useCase: registerUseCase,
                                                                                  navigator: registerNavigator))
        }
    }
}
