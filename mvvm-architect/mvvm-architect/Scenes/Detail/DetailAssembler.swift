//
//  DetailAssembly.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy B on 6/23/20.
//  Copyright © 2020 sun. All rights reserved.
//

// swiftlint:disable force_unwrapping

final class DetailAssembler: Assembly {
    func assemble(container: Container) {
        container.register(DetailUseCaseType.self) { r in
            DetailUseCase(repository: r.resolve(RestaurantsRepository.self)!)
        }

        container.register(DetailViewModel.self) { r, resId in
            DetailViewModel(dependencies: DetailViewModel.Dependencies(id: resId,
                                                                       useCase: r.resolve(DetailUseCaseType.self)!))
        }
    }
}
