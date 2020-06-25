//
//  DetailViewController.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/21/20.
//  Copyright © 2020 sun. All rights reserved.
//

final class DetailViewController: UIViewController, BindableType {
    @IBOutlet var addressLabel: UILabel!

    var viewModel: DetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Address"
    }

    func bindViewModel() {
        let input = DetailViewModel.Input(ready: Driver.just(()))
        let output = viewModel.transform(input: input)

        output.loading
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: rx.disposeBag)

        output.data
            .drive(onNext: { [weak self] data in
                guard let self = self else { return }
                let address = data.location.address
                self.addressLabel.text = address
            })
            .disposed(by: rx.disposeBag)

        output.error
            .drive(onNext: { [weak self] error in
                guard let self = self,
                    let error = error as? APIError else { return }
                self.showAlert(message: error.errorMessage ?? "")
            })
            .disposed(by: rx.disposeBag)
    }
}
