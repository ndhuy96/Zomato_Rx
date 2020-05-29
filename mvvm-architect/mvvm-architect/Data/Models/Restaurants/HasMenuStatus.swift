//
//  HasMenuStatus.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/19/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct HasMenuStatus: Codable {
    let delivery: Int
    let takeaway: Int

    enum CodingKeys: String, CodingKey {
        case delivery
        case takeaway
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        delivery = try values.decodeIfPresent(Int.self, forKey: .delivery) ?? 0
        takeaway = try values.decodeIfPresent(Int.self, forKey: .takeaway) ?? 0
    }
}
