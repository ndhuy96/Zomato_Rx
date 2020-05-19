//
//  PagingInfo.swift
//  mvvm-architect
//
//  Created by can.khac.nguyen on 5/15/20.
//  Copyright © 2020 sun. All rights reserved.
//

import Foundation

struct PagingInfo<T> {
    let totalItems: Int
    let shownItems: Int
    let startItemIndex: Int
    let items: [T]

    init(items: [T], startItemIndex: Int, shownItems: Int = kDefaultRequestItemNumber, totalItems: Int) {
        self.startItemIndex = startItemIndex
        self.shownItems = shownItems
        self.totalItems = totalItems
        self.items = items
    }

    func getItemsDisplayed() -> Int {
        return startItemIndex + shownItems
    }
}
