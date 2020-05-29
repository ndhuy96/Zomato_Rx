//
//  RestaurantInfo.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/19/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct RestaurantInfo: Codable {
    let hasMenuStatus: HasMenuStatus
    let resId: Int

    enum CodingKeys: String, CodingKey {
        case hasMenuStatus = "has_menu_status"
        case resId = "res_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasMenuStatus = try values.decode(HasMenuStatus.self, forKey: .hasMenuStatus)
        resId = try values.decodeIfPresent(Int.self, forKey: .resId) ?? 0
    }
}
