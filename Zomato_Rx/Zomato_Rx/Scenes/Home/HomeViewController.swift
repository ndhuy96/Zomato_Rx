//
//  HomeViewController.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/13/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

let kCollectionViewNumberOfSets: Int = 4
let kCollectionViewLineSpacing: CGFloat = 4.0
let kMaxAutoScrollSpeed: CGFloat = 100
let kMinAutoScrollSpeed: CGFloat = 0
let kCentimeterOf1Inch: CGFloat = 2.54
let kAutoScrollDefaultTimerInterval: CGFloat = 0.01

final class HomeViewController: UIViewController {
    @IBOutlet private var skipButton: UIButton!
    @IBOutlet private var registerButton: UIButton!
    @IBOutlet private var loginWithFBButton: UIButton!
    @IBOutlet private var loginWithGgButton: UIButton!
    @IBOutlet private var dishesCollectionView: InfinityCollectionView!

    private var viewModel: HomeViewModel!
    private var bannerItems: [String] = []
    private var autoScrollSpeed: CGFloat!
    private var timerInterval: CGFloat!
    private var movePointAmountForTimerInterval: CGFloat!
    private var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        config()
        bindViewModel()
    }

    private func setupView() {
        skipButton.setShadow()
    }

    private func config() {
        guard let homeNavigation = navigationController else { return }
        homeNavigation.setNavigationBarHidden(true, animated: false)
        let homeNavigator = HomeNavigator(homeNavigation)
        viewModel = HomeViewModel(dependencies: HomeViewModel.Dependencies(navigator: homeNavigator))

        // CollectionView's Layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = kCollectionViewLineSpacing
        layout.scrollDirection = .horizontal
        let widthContent = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: widthContent, height: widthContent)
        dishesCollectionView.collectionViewLayout = layout

        // CollectionView's Settings
        dishesCollectionView.dataSource = self
        dishesCollectionView.showsVerticalScrollIndicator = false
        dishesCollectionView.showsHorizontalScrollIndicator = false
        dishesCollectionView.scrollsToTop = false
        dishesCollectionView.isUserInteractionEnabled = false
        dishesCollectionView.numberOfSets = kCollectionViewNumberOfSets

        setAutoScrollSpeed(8)
    }

    private func bindViewModel() {
        let input = HomeViewModel.Input(skipTrigger: skipButton.rx.tap.asDriver(),
                                        registerTrigger: registerButton.rx.tap.asDriver(),
                                        loginWithFBTrigger: loginWithFBButton.rx.tap.asDriver(),
                                        loginWithGgTrigger: loginWithGgButton.rx.tap.asDriver())

        let output = viewModel.transform(input: input)

        output.banners
            .drive(onNext: { [weak self] banners in
                guard let self = self else { return }
                self.bannerItems = banners
            })
            .disposed(by: rx.disposeBag)
    }

    private func setAutoScrollSpeed(_ autoScrollSpeed: CGFloat) {
        var availableAutoScrollSpeed: CGFloat
        if autoScrollSpeed > kMaxAutoScrollSpeed {
            availableAutoScrollSpeed = kMaxAutoScrollSpeed
        } else if autoScrollSpeed < kMinAutoScrollSpeed {
            availableAutoScrollSpeed = kMinAutoScrollSpeed
        } else {
            availableAutoScrollSpeed = autoScrollSpeed
        }

        self.autoScrollSpeed = availableAutoScrollSpeed
        if self.autoScrollSpeed > 0 {
            let pixelPerInch = DeviceInfo.getPixelPerInch()
            let movePixelAmountForOneSeconds = self.autoScrollSpeed * CGFloat(pixelPerInch) * 0.1 / kCentimeterOf1Inch
            let movePointForOneSeconds = movePixelAmountForOneSeconds / UIScreen.main.scale
            let movePointAmountForTimerInterval = movePointForOneSeconds * kAutoScrollDefaultTimerInterval
            let floorMovePointAmountForTimerInterval = floor(movePointAmountForTimerInterval)
            if floorMovePointAmountForTimerInterval < 1 {
                self.movePointAmountForTimerInterval = 1
            } else {
                self.movePointAmountForTimerInterval = floorMovePointAmountForTimerInterval
            }
            timerInterval = self.movePointAmountForTimerInterval / movePointForOneSeconds
        }

        startAutoScroll()
    }

    private func startAutoScroll() {
        if timer.isValid {
            return
        }

        if autoScrollSpeed == 0 {
            stopAutoScroll()
        } else {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerInterval),
                                         target: self,
                                         selector: #selector(timerDidFire),
                                         userInfo: nil,
                                         repeats: true)
        }
    }

    private func stopAutoScroll() {
        if timer.isValid {
            timer.invalidate()
        }
    }

    @objc
    private func timerDidFire() {
        let nextContentOffset = CGPoint(x: dishesCollectionView.contentOffset.x + movePointAmountForTimerInterval,
                                        y: dishesCollectionView.contentOffset.y)
        dishesCollectionView.contentOffset = nextContentOffset
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
