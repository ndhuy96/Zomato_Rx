//
//  HomeViewController.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/13/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import GoogleSignIn

final class HomeViewController: AutoScrollViewController, AutoScrollControllerType, BindableType {
    @IBOutlet private var skipButton: UIButton!
    @IBOutlet private var continueWithEmailButton: UIButton!
    @IBOutlet private var loginWithFBButton: UIButton!
    @IBOutlet private var loginWithGgButton: UIButton!
    @IBOutlet private var dishesCollectionView: InfinityCollectionView!

    var collectionView: InfinityCollectionView {
        return dishesCollectionView
    }

    var viewModel: HomeViewModel!
    private var bannerItems: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        config()
    }

    deinit {
        Log.debug(message: "HomeViewController deinit")
    }

    private func setupView() {
        guard let shadowColor = R.color.shadowColor()?.cgColor else { return }
        skipButton.setShadow(shadowColor: shadowColor)
    }

    private func config() {
        guard let homeNavigation = navigationController else { return }
        homeNavigation.setNavigationBarHidden(true, animated: false)

        // CollectionView's Layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = kCollectionViewLineSpacing
        layout.scrollDirection = .horizontal
        let widthContent = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: widthContent, height: widthContent)
        dishesCollectionView.collectionViewLayout = layout

        // CollectionView's Settings
        dishesCollectionView.dataSource = self

        // Google Sign In Settings
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    func bindViewModel() {
        let input = HomeViewModel.Input(skipTrigger: skipButton.rx.tap.asDriver(),
                                        continueWithEmailTrigger: continueWithEmailButton.rx.tap.asDriver(),
                                        loginWithFBTrigger: loginWithFBButton.rx.tap.asDriver(),
                                        loginWithGgTrigger: loginWithGgButton.rx.tap.asDriver())

        let output = viewModel.transform(input: input)

        output.banners
            .drive(onNext: { [weak self] banners in
                guard let self = self else { return }
                self.bannerItems = banners
            })
            .disposed(by: rx.disposeBag)

        output.skip
            .drive()
            .disposed(by: rx.disposeBag)

        output.continueWithEmail
            .drive()
            .disposed(by: rx.disposeBag)

        output.loginWithFB
            .drive()
            .disposed(by: rx.disposeBag)

        output.loginWithGg
            .drive()
            .disposed(by: rx.disposeBag)

        output.loading
            .drive(SVProgressHUD.rx.isAnimating)
            .disposed(by: rx.disposeBag)

        output.error
            .drive(onNext: { [weak self] error in
                guard let self = self,
                    let error = error as? AuthError,
                    error != .cancelled else { return }
                self.showAlert(message: error.message)
            })
            .disposed(by: rx.disposeBag)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return bannerItems.count * dishesCollectionView.numberOfSets
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.dishesCell,
                                                            for: indexPath) else {
            fatalError("`\(R.reuseIdentifier.dishesCell)` is not registed")
        }
        let correctIndexRow = indexPath.row % bannerItems.count
        if bannerItems.count >= correctIndexRow + 1 {
            let item = bannerItems[correctIndexRow]
            cell.configCell(item)
        }
        return cell
    }
}
