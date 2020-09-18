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
    @IBOutlet private weak var establishmentTypeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var openingTimeLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!

    func configCell() {
        let url = URL(string: "https://b.zmtcdn.com/data/reviews_photos/68f/36640dcaceea750d1e59d790524ff68f_1597784739.jpg?fit=around%7C200%3A200&crop=200%3A200%3B%2A%2C%2A")
        thumbImageView.kf.setImage(with: url)
    }
}
