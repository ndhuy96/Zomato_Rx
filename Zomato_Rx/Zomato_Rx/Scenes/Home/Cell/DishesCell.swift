//
//  DishesCell.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/18/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

final class DishesCell: UICollectionViewCell {
    @IBOutlet var dishImageView: UIImageView!

    func configCell(_ imageString: String) {
        dishImageView.image = UIImage(named: imageString)
    }
}
