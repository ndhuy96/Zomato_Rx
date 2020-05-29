//
//  DetailViewModel.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/21/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct DetailViewModel: ViewModelType {
    struct Input {
        let ready: Driver<Void>
    }

    struct Output {
        let loading: Driver<Bool>
        let data: Driver<RestaurantDetail>
        let error: Driver<Error>
    }

    struct Dependencies {
        let id: String
        let api: RestaurantsRepository
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func transform(input: DetailViewModel.Input) -> DetailViewModel.Output {
        let activityIndicator = ActivityIndicator()
        let loading = activityIndicator.asDriver()
        let errorTracker = ErrorTracker()

        let data = input.ready
            .asObservable()
            .flatMapLatest { _ in
                self.dependencies.api.fetchRestaurantDetail(with: self.dependencies.id)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
            }
            .map { restaurant -> RestaurantDetail in
                restaurant
            }
            .asDriverOnErrorJustComplete()

        let errors = errorTracker.asDriver()

        return Output(loading: loading, data: data, error: errors)
    }
}
