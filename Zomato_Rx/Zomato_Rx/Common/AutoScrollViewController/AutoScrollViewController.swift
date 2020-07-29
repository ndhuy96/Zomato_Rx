//
//  AutoScrollViewController.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/2/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

let kCollectionViewNumberOfSets: Int = 4
let kCollectionViewLineSpacing: CGFloat = 4.0
let kMaxAutoScrollSpeed: CGFloat = 100
let kMinAutoScrollSpeed: CGFloat = 0
let kAutoScrollSpeed: CGFloat = 8
let kCentimeterOf1Inch: CGFloat = 2.54
let kAutoScrollDefaultTimerInterval: CGFloat = 0.01

// swiftlint:disable final_class
class AutoScrollViewController: UIViewController {
    private var infinityCollectionView: InfinityCollectionView!
    private var autoScrollSpeed: CGFloat!
    private var timerInterval: CGFloat!
    private var movePointAmountForTimerInterval: CGFloat!
    private var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let controller = self as? AutoScrollControllerType {
            infinityCollectionView = controller.collectionView
        }
        config()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScroll()
    }

    private func config() {
        // CollectionView's Settings
        infinityCollectionView.showsVerticalScrollIndicator = false
        infinityCollectionView.showsHorizontalScrollIndicator = false
        infinityCollectionView.scrollsToTop = false
        infinityCollectionView.isUserInteractionEnabled = false
        infinityCollectionView.numberOfSets = kCollectionViewNumberOfSets

        setAutoScrollSpeed(kAutoScrollSpeed)
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
        let nextContentOffset = CGPoint(x: infinityCollectionView.contentOffset.x + movePointAmountForTimerInterval,
                                        y: infinityCollectionView.contentOffset.y)
        infinityCollectionView.contentOffset = nextContentOffset
    }
}
