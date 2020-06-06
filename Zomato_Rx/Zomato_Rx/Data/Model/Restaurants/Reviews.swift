//
//  Reviews.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
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
