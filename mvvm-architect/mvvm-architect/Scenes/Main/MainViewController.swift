//
//  MainViewController.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/14/20.
//  Copyright © 2020 sun. All rights reserved.
//

final class MainViewController: UIViewController {
    @IBOutlet private var restaurantsTableView: UITableView!
    private var refreshControl: UIRefreshControl!
    private var bottomRefreshControl: UIRefreshControl!

    private var viewModel: MainViewModel!

    var api: RestaurantsRepository?
    var count: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        bindViewModel()
    }

    private func config() {
        guard let mainNavigation = navigationController,
            let api = api,
            let count = count else { return }

        let mainNavigator = MainNavigator(mainNavigation)
        viewModel = MainViewModel(dependencies: MainViewModel.Dependencies(api: api,
                                                                           count: count,
                                                                           navigator: mainNavigator))

        // TableView's settings
        restaurantsTableView.registerNib(RestaurantCell.self)
        restaurantsTableView.delegate = self
        restaurantsTableView.tableFooterView = UIView()

        // TableView's refresh control
        refreshControl = UIRefreshControl()
        restaurantsTableView.refreshControl = refreshControl

        // TableView's loadmore
        bottomRefreshControl = UIRefreshControl()
        refreshControl.triggerVerticalOffset = 100
        restaurantsTableView.bottomRefreshControl = bottomRefreshControl
    }

    private func bindViewModel() {
        let input = MainViewModel.Input(ready: Driver.just(()),
                                        refreshing: refreshControl.rx.controlEvent(.valueChanged).asDriver(),
                                        loadingMore: bottomRefreshControl.rx.controlEvent(.valueChanged).asDriver(),
                                        selected: restaurantsTableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)

        output.loading
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: rx.disposeBag)

        output.isRefreshing
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: rx.disposeBag)

        output.isLoadingMore
            .drive(bottomRefreshControl.rx.isRefreshing)
            .disposed(by: rx.disposeBag)

        output.fetchItems
            .drive()
            .disposed(by: rx.disposeBag)

        // TODO: display empty view if had
        output.isEmpty
            .drive()
            .disposed(by: rx.disposeBag)

        output.restaurants
            .drive(restaurantsTableView.rx.items) { tableView, _, restaurants -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(RestaurantCell.self)
                let restaurant = restaurants.restaurant
                cell.configCell(restaurant)
                return cell
            }
            .disposed(by: rx.disposeBag)

        output.error
            .drive(onNext: { [weak self] error in
                guard let self = self,
                    let error = error as? APIError else { return }
                self.showAlert(message: error.errorMessage ?? "")
            })
            .disposed(by: rx.disposeBag)

        output.selected
            .drive()
            .disposed(by: rx.disposeBag)
    }
}

// MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }
}
