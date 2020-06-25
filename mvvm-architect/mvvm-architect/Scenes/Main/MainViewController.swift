//
//  MainViewController.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/14/20.
//  Copyright © 2020 sun. All rights reserved.
//

final class MainViewController: UIViewController, BindableType {
    @IBOutlet private var restaurantsTableView: LoadMoreTableView!

    var viewModel: MainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    private func config() {
        // TableView's settings
        restaurantsTableView.registerNib(RestaurantCell.self)
        restaurantsTableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        restaurantsTableView.tableFooterView = UIView()
    }

    func bindViewModel() {
        let input = MainViewModel.Input(ready: Driver.just(()),
                                        refreshing: restaurantsTableView.refreshTrigger,
                                        loadingMore: restaurantsTableView.loadMoreTrigger,
                                        selected: restaurantsTableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)

        output.loading
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: rx.disposeBag)

        output.isRefreshing
            .drive(restaurantsTableView.refreshing)
            .disposed(by: rx.disposeBag)

        output.isLoadingMore
            .drive(restaurantsTableView.loadingMore)
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
