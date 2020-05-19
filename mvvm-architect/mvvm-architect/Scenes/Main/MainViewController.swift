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

    private var viewModel: MainViewModel!

    private var disposeBag = DisposeBag()
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
    }

    private func bindViewModel() {
        let indexPathWillDisplay = restaurantsTableView.rx.willDisplayCell
            .map { $0.indexPath }
            .asDriverOnErrorJustComplete()
        let input = MainViewModel.Input(ready: rx.viewWillAppear.asDriver(),
                                        refreshing: refreshControl.rx.controlEvent(.valueChanged).asDriver(),
                                        selected: restaurantsTableView.rx.itemSelected.asDriver(),
                                        indexPathWillDisplay: indexPathWillDisplay)
        let output = viewModel.transform(input: input)

        output.loading
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)

        output.isRefreshing
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        output.isLoadingMore
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)

        output.fetchItems
            .drive()
            .disposed(by: disposeBag)

        output.indexPathWillDisplayDriver
            .drive()
            .disposed(by: disposeBag)

        // TODO: display empty view if had
        output.isEmpty
            .drive()
            .disposed(by: disposeBag)

        output.restaurants
            .drive(restaurantsTableView.rx.items) { tableView, _, restaurants -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(RestaurantCell.self)
                guard let restaurant = restaurants.restaurant else { return UITableViewCell() }
                cell.configCell(restaurant)
                return cell
            }
            .disposed(by: disposeBag)

        output.error
            .drive(onNext: { [weak self] error in
                guard let self = self,
                    let error = error as? APIError else { return }
                self.showAlert(message: error.errorMessage ?? "")
            })
            .disposed(by: disposeBag)

        output.selected
            .drive()
            .disposed(by: disposeBag)
    }
}

// MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }
}
