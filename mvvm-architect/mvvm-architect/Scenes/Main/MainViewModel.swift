//
//  MainViewModel.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/20/20.
//  Copyright © 2020 sun. All rights reserved.
//

final class MainViewModel: ViewModelType {
    struct Input {
        let ready: Driver<Void>
        let refreshing: Driver<Void>
        let selected: Driver<IndexPath>
        let indexPathWillDisplay: Driver<IndexPath>
    }

    struct Output {
        let loading: Driver<Bool>
        let restaurants: Driver<[Restaurants]>
        let isLoadingMore: Driver<Bool>
        let isRefreshing: Driver<Bool>
        let fetchItems: Driver<Void>
        let isEmpty: Driver<Bool>
        let indexPathWillDisplayDriver: Driver<Void>
        let selected: Driver<Void>
        let error: Driver<Error>
    }

    struct Dependencies {
        let api: RestaurantsRepository
        let count: Int
        let navigator: MainNavigatable
    }

    private let dependencies: Dependencies
    private let loadMoreTrigger = PublishRelay<Void>()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func transform(input: Input) -> Output {
        let dataInfo = setUpLoadMorePaging(loadTrigger: input.ready,
                                           getItems: dependencies.api.fetchRestaurants,
                                           refreshTrigger: input.refreshing,
                                           refreshItems: dependencies.api.fetchRestaurants,
                                           loadMoreTrigger: loadMoreTrigger.asDriverOnErrorJustComplete(),
                                           loadMoreItems: dependencies.api.fetchRestaurants)
        let (pagingInfo, fetchItems, errors, isLoading, isRefreshing, isLoadingMore) = dataInfo
        let restaurants = pagingInfo.map { $0.items }.asDriverOnErrorJustComplete()
        let isEmpty = restaurants.map { $0.isEmpty }
        let indexPathWillDisplayDriver = input.indexPathWillDisplay
            .withLatestFrom(pagingInfo.asDriver()) { ($0, $1) }
            .filter { $0.0.row >= $0.1.getItemsDisplayed() - 1 }
            .do(onNext: { [weak self] _ in
                self?.loadMoreTrigger.accept(())
            })
            .mapToVoid()
        let selected = input.selected
            .asObservable()
            .withLatestFrom(restaurants) { ($0, $1) }
            .do(onNext: { [weak self] (indexPath: IndexPath, restaurants: [Restaurants]) in
                guard let self = self,
                    let resId = restaurants[indexPath.row].restaurant?.id else { return }
                self.dependencies.navigator.navigateToDetailScreen(with: resId, api: self.dependencies.api)
            })
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        return Output(loading: isLoading,
                      restaurants: restaurants,
                      isLoadingMore: isLoadingMore,
                      isRefreshing: isRefreshing,
                      fetchItems: fetchItems,
                      isEmpty: isEmpty,
                      indexPathWillDisplayDriver: indexPathWillDisplayDriver,
                      selected: selected,
                      error: errors)
    }
}
