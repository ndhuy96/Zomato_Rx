//
//  HasMenuStatus.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
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
