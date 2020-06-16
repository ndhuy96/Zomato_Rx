//
//  HomeViewModel.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/18/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

let kNumberOfBanners: Int = 6

struct HomeViewModel: ViewModelType {
    struct Input {
        let skipTrigger: Driver<Void>
        let registerTrigger: Driver<Void>
        let loginWithFBTrigger: Driver<Void>
        let loginWithGgTrigger: Driver<Void>
    }

    struct Output {
        let banners: Driver<[String]>
    }

    struct Dependencies {
        let navigator: HomeNavigatable
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func transform(input _: Input) -> Output {
        // Initial Data
        var bannerItems: [String] = []
        for n in 1 ... kNumberOfBanners {
            bannerItems.append("login_scroller_\(n)_Normal")
        }

        let banners = Observable.just(bannerItems)
            .asDriver(onErrorJustReturn: [])
        return Output(banners: banners)
    }
}
