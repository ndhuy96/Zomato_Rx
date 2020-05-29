//
//  CategoryCell.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/21/20.
//  Copyright © 2020 sun. All rights reserved.
//

final class RestaurantCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!

    func configCell(_ res: Restaurant) {
        titleLabel.text = res.name
    }
}
