//
//  AllReviews.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/19/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct AllReviews: Codable {
    let reviews: [Reviews]

    enum CodingKeys: String, CodingKey {
        case reviews
    }
}
