//
//  DiningNavigator.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 9/22/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

protocol DiningNavigatable {
    func navigateToDetailScreen(with resId: String)
}

struct DiningNavigator: DiningNavigatable {
    private unowned let navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigateToDetailScreen(with resId: String) {
        print(resId)
    }
}
