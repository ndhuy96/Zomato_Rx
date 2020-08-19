//
//  InfinityCollectionView.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/18/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

final class InfinityCollectionView: UICollectionView {
    var numberOfSets: Int!

    override func layoutSubviews() {
        super.layoutSubviews()
        let centerOffsetX = contentSize.width / 2.0
        let distanceX = abs(contentOffset.x - centerOffsetX) // convert absolute value
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let oneSetWidth = (contentSize.width + flowLayout.minimumLineSpacing) / CGFloat(numberOfSets)
            if distanceX > oneSetWidth {
                // When one set has been scrolled, it returns to original position
                // fmodf = num1 - integerValue * num2
                let offset = fmodf(Float(contentOffset.x - centerOffsetX), Float(oneSetWidth))
                contentOffset = CGPoint(x: centerOffsetX + CGFloat(offset), y: contentOffset.y)
            }
        }
    }
}
