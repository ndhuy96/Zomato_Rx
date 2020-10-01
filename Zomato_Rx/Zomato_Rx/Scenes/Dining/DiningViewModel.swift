//
//  DiningViewModel.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 9/22/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

struct DiningViewModel: ViewModelType {
    struct Input {
        let ready: Driver<Void>
        let refreshing: Driver<Void>
        let loadingMore: Driver<Void>
        let selected: Driver<IndexPath>
    }

    struct Output {
        let loading: Driver<Bool>
        let restaurants: Driver<[Restaurants]>
        let isLoadingMore: Driver<Bool>
        let isRefreshing: Driver<Bool>
        let fetchItems: Driver<Void>
        let isEmpty: Driver<Bool>
        let selected: Driver<Void>
        let error: Driver<Error>
    }

    struct Dependencies {
        let navigator: DiningNavigatable
        let useCase: DiningUseCaseType
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func transform(input: Input) -> Output {
        let dataInfo = setUpLoadMorePaging(loadTrigger: input.ready,
                                           getItems: dependencies.useCase.getRestaurantsList,
                                           refreshTrigger: input.refreshing,
                                           refreshItems: dependencies.useCase.getRestaurantsList,
                                           loadMoreTrigger: input.loadingMore,
                                           loadMoreItems: dependencies.useCase.loadMoreRestaurantsList)

        let (pagingInfo, fetchItems, errors, isLoading, isRefreshing, isLoadingMore) = dataInfo

        let restaurants = pagingInfo.map {
            $0.items
        }
        .asDriverOnErrorJustComplete()

        let isEmpty = restaurants.map { $0.isEmpty }

        let selected = input.selected
            .asObservable()
            .withLatestFrom(restaurants) { ($0, $1) }
            .do(onNext: { (indexPath: IndexPath, restaurants: [Restaurants]) in
                let resId = restaurants[indexPath.row].restaurant.id
                self.dependencies.navigator.navigateToDetailScreen(with: resId)
            })
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        return Output(loading: isLoading,
                      restaurants: restaurants,
                      isLoadingMore: isLoadingMore,
                      isRefreshing: isRefreshing,
                      fetchItems: fetchItems,
                      isEmpty: isEmpty,
                      selected: selected,
                      error: errors)
    }
}
