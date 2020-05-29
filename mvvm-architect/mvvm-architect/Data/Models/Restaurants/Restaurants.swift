//
//  Restaurants.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/19/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct Restaurants: Codable {
    let restaurant: Restaurant

    enum CodingKeys: String, CodingKey {
        case restaurant
    }
}
