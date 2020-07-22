//
//  DetailAssembly.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy B on 6/23/20.
//  Copyright © 2020 sun. All rights reserved.
//

final class DetailAssembler: Assembly {
    func assemble(container: Container) {
        container.register(DetailViewModel.self) { (_, resId: String, restaurantsRepository: RestaurantsRepository) in
            let detailUseCase = DetailUseCase(repository: restaurantsRepository)
            return DetailViewModel(dependencies: DetailViewModel.Dependencies(id: resId,
                                                                              useCase: detailUseCase))
        }
    }
}
