//
//  User.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

struct User: Codable {
    let name: String
    let foodieColor: String
    let profileUrl: String
    let profileImage: String
    let profileDeeplink: String

    enum CodingKeys: String, CodingKey {
        case name
        case foodieColor = "foodie_color"
        case profileUrl = "profile_url"
        case profileImage = "profile_image"
        case profileDeeplink = "profile_deeplink"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        foodieColor = try values.decodeIfPresent(String.self, forKey: .foodieColor) ?? ""
        profileUrl = try values.decodeIfPresent(String.self, forKey: .profileUrl) ?? ""
        profileImage = try values.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
        profileDeeplink = try values.decodeIfPresent(String.self, forKey: .profileDeeplink) ?? ""
    }
}
