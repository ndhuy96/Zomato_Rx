//
//  App.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/8/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

final class App {
    static var shared = App()

    private init() {}

    var window: UIWindow!

    func startInterface() {
        guard let homeNavigationController = R.storyboard.home.homeNavigationController() else { return }
        let tabBarController = R.storyboard.tabBar.tabBarController()

        if UserDefaultsManager.shared.get(.loggedIn) { // check whether user logged or not
            window.rootViewController = tabBarController
        } else {
            window.rootViewController = homeNavigationController
        }

        window.makeKeyAndVisible()
    }

    func moveToTabBarScreen() {
        guard let tabBarController = R.storyboard.tabBar.tabBarController() else { return }

        let snapShot = window.snapshotView(afterScreenUpdates: true)
        if let snapShot = snapShot {
            tabBarController.view.addSubview(snapShot)
        }
        window.rootViewController = tabBarController

        let moveDown = CGAffineTransform(translationX: 0, y: window.frame.height)
        UIView.animate(withDuration: 0.3,
                       animations: {
                           snapShot?.transform = moveDown
                       },
                       completion: { _ in
                           snapShot?.removeFromSuperview()
                       })
    }

    func backToHomeScreen() {
        guard let homeNavigationController = R.storyboard.home.homeNavigationController() else { return }
        let snapShot = window.snapshotView(afterScreenUpdates: true)
        if let snapShot = snapShot {
            homeNavigationController.view.addSubview(snapShot)
        }
        window.rootViewController = homeNavigationController

        UIView.animate(withDuration: 0.3,
                       animations: {
                           snapShot?.layer.opacity = 0
                           snapShot?.layer.transform = CATransform3DMakeScale(1, 1, 1)
                       },
                       completion: { _ in
                           snapShot?.removeFromSuperview()
                       })
    }
}
