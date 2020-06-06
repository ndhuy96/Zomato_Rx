//
//  ListRestaurants.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

struct ListRestaurants: Codable {
    let resultsFound: Int
    let resultsStart: Int
    let resultsShown: Int
    let restaurants: [Restaurants]

    enum CodingKeys: String, CodingKey {
        case resultsFound = "results_found"
        case resultsStart = "results_start"
        case resultsShown = "results_shown"
        case restaurants
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultsFound = try values.decodeIfPresent(Int.self, forKey: .resultsFound) ?? 0
        resultsStart = try values.decodeIfPresent(Int.self, forKey: .resultsStart) ?? 0
        resultsShown = try values.decodeIfPresent(Int.self, forKey: .resultsShown) ?? 0
        restaurants = try values.decode([Restaurants].self, forKey: .restaurants)
    }
}
