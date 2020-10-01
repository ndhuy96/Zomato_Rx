//
//  ViewModelType+LoadMore.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 9/22/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

// swiftlint:disable large_tuple
extension ViewModelType {
    func setUpLoadMorePaging<T>(loadTrigger: Driver<Void>,
                                getItems: @escaping () -> Single<PagingInfo<T>>,
                                refreshTrigger: Driver<Void>,
                                refreshItems: @escaping () -> Single<PagingInfo<T>>,
                                loadMoreTrigger: Driver<Void>,
                                loadMoreItems: @escaping (Int) -> Single<PagingInfo<T>>)
        -> (page: BehaviorRelay<PagingInfo<T>>,
            fetchItems: Driver<Void>,
            error: Driver<Error>,
            loading: Driver<Bool>,
            refreshing: Driver<Bool>,
            loadingMore: Driver<Bool>)
    {
        return setupLoadMorePagingWithParam(
            loadTrigger: loadTrigger,
            getItems: { _ in
                getItems()
            },
            refreshTrigger: refreshTrigger,
            refreshItems: { _ in
                refreshItems()
            },
            loadMoreTrigger: loadMoreTrigger,
            loadMoreItems: { _, start in
                loadMoreItems(start)
            }
        )
    }
}

extension ViewModelType {
    func setupLoadMorePagingWithParam<T, U>(loadTrigger: Driver<U>,
                                            getItems: @escaping (U) -> Single<PagingInfo<T>>,
                                            refreshTrigger: Driver<U>,
                                            refreshItems: @escaping (U) -> Single<PagingInfo<T>>,
                                            loadMoreTrigger: Driver<U>,
                                            loadMoreItems: @escaping (U, Int) -> Single<PagingInfo<T>>)
        -> (page: BehaviorRelay<PagingInfo<T>>,
            fetchItems: Driver<Void>,
            error: Driver<Error>,
            loading: Driver<Bool>,
            refreshing: Driver<Bool>,
            loadingMore: Driver<Bool>)
    {
        let pageSubject = BehaviorRelay<PagingInfo<T>>(value: PagingInfo<T>(items: [],
                                                                            startItemIndex: 0,
                                                                            shownItems: 0,
                                                                            totalItems: 0))
        let errorTracker = ErrorTracker()
        let loadingActivityIndicator = ActivityIndicator()
        let refreshingActivityIndicator = ActivityIndicator()
        let loadingMoreActivityIndicator = ActivityIndicator()

        let loading = loadingActivityIndicator.asDriver()
        let refreshing = refreshingActivityIndicator.asDriver()
        let loadingMore = loadingMoreActivityIndicator.asDriver()

        let loadingOrLoadingMore = Driver.merge(loading, refreshing, loadingMore)
            .startWith(false)

        let loadItems = loadTrigger
            .withLatestFrom(loadingOrLoadingMore) {
                (arg: $0, loading: $1)
            }
            .filter { !$0.loading }
            .map { $0.arg }
            .flatMapLatest { arg in
                getItems(arg)
                    .trackError(errorTracker)
                    .trackActivity(loadingActivityIndicator)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { page in
                pageSubject.accept(page)
            })
            .mapToVoid()

        let refreshItems = refreshTrigger
            .withLatestFrom(loadingOrLoadingMore) {
                (arg: $0, loading: $1)
            }
            .filter { !$0.loading }
            .map { $0.arg }
            .flatMapLatest { arg in
                refreshItems(arg)
                    .trackError(errorTracker)
                    .trackActivity(refreshingActivityIndicator)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { page in
                pageSubject.accept(page)
            })
            .mapToVoid()

        let loadMoreItems = loadMoreTrigger
            .withLatestFrom(loadingOrLoadingMore) {
                (arg: $0, loading: $1)
            }
            .filter { !$0.loading }
            .map { $0.arg }
            .filter { _ in !pageSubject.value.items.isEmpty }
            .flatMapLatest { arg -> Driver<PagingInfo<T>> in
                let start = pageSubject.value.getItemsDisplayed()
                return loadMoreItems(arg, start)
                    .trackError(errorTracker)
                    .trackActivity(loadingMoreActivityIndicator)
                    .asDriverOnErrorJustComplete()
            }
            .filter { !$0.items.isEmpty }
            .do(onNext: { page in
                let currentPage = pageSubject.value
                let items: [T] = currentPage.items + page.items
                let newPage = PagingInfo<T>(items: items,
                                            startItemIndex: page.startItemIndex,
                                            shownItems: page.shownItems,
                                            totalItems: page.totalItems)
                pageSubject.accept(newPage)
            })
            .mapToVoid()

        let fetchItems = Driver.merge(loadItems, refreshItems, loadMoreItems)
        return (pageSubject,
                fetchItems,
                errorTracker.asDriver(),
                loading,
                refreshing,
                loadingMore)
    }
}
