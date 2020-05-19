//
//  RestaurantsRepositories.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/22/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol RestaurantsRepository {
    func fetchRestaurants() -> Single<PagingInfo<Restaurants>>
    func fetchRestaurants(start: Int, count: Int) -> Single<PagingInfo<Restaurants>>
    func fetchRestaurantDetail(with resId: String) -> Single<RestaurantDetail>
}

final class RestaurantsRepositoryImpl: RestaurantsRepository {
    private let api: APIService

    required init(_ api: APIService) {
        self.api = api
    }

    func fetchRestaurants() -> Single<PagingInfo<Restaurants>> {
        let router = APIRouter.search(start: 0)
        let restaurantResults: Single<ListRestaurants> = api.request(router: router)
        return restaurantResults.map { PagingInfo(items: $0.restaurants ?? [],
                                                  startItemIndex: $0.resultsStart ?? 0,
                                                  totalItems: $0.resultsFound ?? 0)
        }
    }

    func fetchRestaurants(start: Int, count _: Int) -> Single<PagingInfo<Restaurants>> {
        let router = APIRouter.search(start: start)
        let restaurantResults: Single<ListRestaurants> = api.request(router: router)
        return restaurantResults.map { PagingInfo(items: $0.restaurants ?? [],
                                                  startItemIndex: $0.resultsStart ?? 0,
                                                  totalItems: $0.resultsFound ?? 0)
        }
    }

    func fetchRestaurantDetail(with resId: String) -> Single<RestaurantDetail> {
        let router = APIRouter.fetchResDetail(resId: resId)
        return api.request(router: router)
    }
}
