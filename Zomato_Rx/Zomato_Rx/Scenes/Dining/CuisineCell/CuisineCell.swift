//
//  CuisineCell.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 9/13/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import Kingfisher

final class CuisineCell: UITableViewCell {
    @IBOutlet private weak var thumbImageView: UIImageView!
    @IBOutlet private weak var cuisineTitleLabel: UILabel!
    @IBOutlet private weak var establishmentsLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var openingTimeLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var separateLine: UILabel!

    func configCell(restaurant: Restaurant) {
        cuisineTitleLabel.text = restaurant.name
        let establishments = restaurant.establishment
            .prefix(2)
            .joined(separator: " - ")
        if !establishments.isEmpty {
            establishmentsLabel.text = establishments
        } else {
            establishmentsLabel.text = "Casual Dining"
        }

        addressLabel.text = restaurant.location.address
        openingTimeLabel.text = restaurant.timings
        separateLine.isHidden = restaurant.timings.isEmpty
        ratingLabel.text = restaurant.userRating.aggregateRating.rawValue
        ratingLabel.backgroundColor = UIColor(hexString: restaurant.userRating.ratingColor)

        let url = URL(string: restaurant.thumb)
        print("huybnd: ", restaurant.thumb)
        thumbImageView.kf.setImage(with: url)
    }
}
