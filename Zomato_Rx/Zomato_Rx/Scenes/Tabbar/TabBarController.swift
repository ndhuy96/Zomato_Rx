//
//  TabBarController.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/8/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        Log.debug(message: "TabBarController deinit")
    }
}
