//
//  Restaurants.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

struct Restaurants: Codable {
    let restaurant: Restaurant

    enum CodingKeys: String, CodingKey {
        case restaurant
    }
}
