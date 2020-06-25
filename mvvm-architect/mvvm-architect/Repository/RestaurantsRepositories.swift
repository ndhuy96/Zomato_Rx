//
//  RestaurantsRepositories.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/22/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol RestaurantsRepository {
    func fetchRestaurants(start: Int, count: Int) -> Single<PagingInfo<Restaurants>>
    func fetchRestaurantDetail(with resId: String) -> Single<RestaurantDetail>
}

final class RestaurantsRepositoryImpl: RestaurantsRepository {
    private let api: APIService

    required init(_ api: APIService) {
        self.api = api
    }

    func fetchRestaurants(start: Int, count: Int) -> Single<PagingInfo<Restaurants>> {
        let router = APIRouter.search(start: start, count: count)
        let restaurantResults: Single<ListRestaurants> = api.request(router: router)
        return restaurantResults.map { PagingInfo(items: $0.restaurants,
                                                  startItemIndex: $0.resultsStart,
                                                  shownItems: count,
                                                  totalItems: $0.resultsFound)
        }
    }

    func fetchRestaurantDetail(with resId: String) -> Single<RestaurantDetail> {
        let router = APIRouter.fetchResDetail(resId: resId)
        return api.request(router: router)
    }
}
