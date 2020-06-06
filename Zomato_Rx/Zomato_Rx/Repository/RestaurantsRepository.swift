//
//  RestaurantsRepository.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

protocol RestaurantsRepository {
    func fetchRestaurants(start: Int, count: Int) -> Single<PagingInfo<Restaurants>>
}

final class RestaurantsRepositoryImpl: RestaurantsRepository {
    private let api: APIService

    required init(_ api: APIService) {
        self.api = api
    }

    func fetchRestaurants(start: Int, count _: Int) -> Single<PagingInfo<Restaurants>> {
        let router = APIRouter.search(start: start)
        let restaurantResults: Single<ListRestaurants> = api.request(router: router)
        return restaurantResults.map { PagingInfo(items: $0.restaurants,
                                                  startItemIndex: $0.resultsStart,
                                                  totalItems: $0.resultsFound)
        }
    }
}
