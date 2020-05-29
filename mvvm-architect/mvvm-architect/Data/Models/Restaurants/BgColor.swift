//
//  BgColor.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/19/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct BgColor: Codable {
    let type: String
    let tint: String

    enum CodingKeys: String, CodingKey {
        case type
        case tint
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type) ?? ""
        tint = try values.decodeIfPresent(String.self, forKey: .tint) ?? ""
    }
}
