//
//  MainUseCase.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy B on 6/22/20.
//  Copyright © 2020 sun. All rights reserved.
//

let kDefaultRequestStartNumber: Int = 0
let kDefaultRequestItemNumber: Int = 20

protocol MainUseCaseType {
    func getRestaurantsList() -> Single<PagingInfo<Restaurants>>
    func loadMoreRestaurantsList(start: Int) -> Single<PagingInfo<Restaurants>>
}

struct MainUseCase: MainUseCaseType {
    let repository: RestaurantsRepository

    func getRestaurantsList() -> Single<PagingInfo<Restaurants>> {
        return loadMoreRestaurantsList(start: kDefaultRequestStartNumber)
    }

    func loadMoreRestaurantsList(start: Int) -> Single<PagingInfo<Restaurants>> {
        return repository.fetchRestaurants(start: start, count: kDefaultRequestItemNumber)
    }
}
