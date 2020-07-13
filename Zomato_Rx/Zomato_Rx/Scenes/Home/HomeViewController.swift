//
//  HomeViewController.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/13/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

final class HomeViewController: AutoScrollViewController, AutoScrollControllerType, BindableType {
    @IBOutlet private var skipButton: UIButton!
    @IBOutlet private var registerButton: UIButton!
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
    }

    func bindViewModel() {
        let input = HomeViewModel.Input(skipTrigger: skipButton.rx.tap.asDriver(),
                                        registerTrigger: registerButton.rx.tap.asDriver(),
                                        loginWithFBTrigger: loginWithFBButton.rx.tap
                                            .map { [unowned self] _ in self }
                                            .asDriverOnErrorJustComplete(),
                                        loginWithGgTrigger: loginWithGgButton.rx.tap
                                            .map { [unowned self] _ in self }
                                            .asDriverOnErrorJustComplete())

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

        output.register
            .drive()
            .disposed(by: rx.disposeBag)

        output.loginWithFB
            .drive()
            .disposed(by: rx.disposeBag)

        output.loginWithGg
            .drive()
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
