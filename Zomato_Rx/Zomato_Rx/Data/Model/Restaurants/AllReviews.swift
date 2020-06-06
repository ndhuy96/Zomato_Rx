//
//  AllReviews.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

struct AllReviews: Codable {
    let reviews: [Reviews]

    enum CodingKeys: String, CodingKey {
        case reviews
    }
}
