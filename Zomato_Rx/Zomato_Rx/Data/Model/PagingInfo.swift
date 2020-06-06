//
//  PagingInfo.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

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
