//
//  DiningViewController.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy B on 5/29/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

final class DiningViewController: UIViewController, BindableType {
    @IBOutlet private weak var locationButton: UIButton!
    @IBOutlet private weak var cuisineTableView: LoadMoreTableView!
    @IBOutlet private weak var bgImageView: UIImageView!

    var viewModel: DiningViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    private func config() {
        locationButton.titleLabel?.numberOfLines = 1
        locationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        locationButton.titleLabel?.lineBreakMode = .byClipping

        cuisineTableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)

        cuisineTableView.tableFooterView = UIView()
    }

    func bindViewModel() {
        let input = DiningViewModel.Input(ready: Driver.just(()),
                                          refreshing: cuisineTableView.refreshTrigger,
                                          loadingMore: cuisineTableView.loadMoreTrigger,
                                          selected: cuisineTableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)

        output.loading
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: rx.disposeBag)

        output.loading
            .drive(SVProgressHUD.rx.isAnimating)
            .disposed(by: rx.disposeBag)

        output.isRefreshing
            .drive(cuisineTableView.refreshing)
            .disposed(by: rx.disposeBag)

        output.isLoadingMore
            .drive(cuisineTableView.loadingMore)
            .disposed(by: rx.disposeBag)

        output.fetchItems
            .drive()
            .disposed(by: rx.disposeBag)

        output.isEmpty
            .drive(onNext: { [weak self] isEmpty in
                self?.bgImageView.isHidden = isEmpty
            })
            .disposed(by: rx.disposeBag)

        output.restaurants
            .drive(cuisineTableView.rx.items) { tableView, _, restaurants -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(CuisineCell.self)
                let restaurant = restaurants.restaurant
                cell.configCell(restaurant: restaurant)
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

extension DiningViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }
}
