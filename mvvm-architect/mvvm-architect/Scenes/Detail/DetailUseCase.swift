//
//  DetailUseCase.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy B on 6/22/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol DetailUseCaseType {
    func getRestaurantDetail(with resId: String) -> Single<RestaurantDetail>
}

struct DetailUseCase: DetailUseCaseType {
    let repository: RestaurantsRepository

    func getRestaurantDetail(with resId: String) -> Single<RestaurantDetail> {
        return repository.fetchRestaurantDetail(with: resId)
    }
}
