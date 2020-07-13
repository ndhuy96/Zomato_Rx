//
//  AutoScrollControllerType.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/2/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

protocol AutoScrollControllerType {
    var collectionView: InfinityCollectionView { get }
}

extension AutoScrollControllerType {
    var collectionView: InfinityCollectionView {
        return InfinityCollectionView()
    }
}
