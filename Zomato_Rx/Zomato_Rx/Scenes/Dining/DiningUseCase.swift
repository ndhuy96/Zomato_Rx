//
//  DiningUseCase.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 9/22/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

protocol DiningUseCaseType {
    func getRestaurantsList() -> Single<PagingInfo<Restaurants>>
    func loadMoreRestaurantsList(start: Int) -> Single<PagingInfo<Restaurants>>
}

struct DiningUseCase: DiningUseCaseType {
    let repository: RestaurantsRepository

    func getRestaurantsList() -> Single<PagingInfo<Restaurants>> {
        return loadMoreRestaurantsList(start: kDefaultRequestStartNumber)
    }

    func loadMoreRestaurantsList(start: Int) -> Single<PagingInfo<Restaurants>> {
        return repository.fetchRestaurants(start: start, count: kDefaultRequestItemNumber)
    }
}
