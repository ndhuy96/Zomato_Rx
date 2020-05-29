//
//  Reviews.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/19/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct Reviews: Codable {
    let review: [String]

    enum CodingKeys: String, CodingKey {
        case review
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        review = try values.decodeIfPresent([String].self, forKey: .review) ?? []
    }
}
