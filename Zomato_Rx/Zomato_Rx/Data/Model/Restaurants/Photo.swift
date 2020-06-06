//
//  Photo.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

struct Photo: Codable {
    let id: String
    let url: String
    let thumbUrl: String
    let user: User
    let resId: Int
    let caption: String
    let timestamp: Int
    let friendlyTime: String
    let width: Int
    let height: Int

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case thumbUrl = "thumb_url"
        case user
        case resId = "res_id"
        case caption
        case timestamp
        case friendlyTime = "friendly_time"
        case width
        case height
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        url = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
        thumbUrl = try values.decodeIfPresent(String.self, forKey: .thumbUrl) ?? ""
        user = try values.decode(User.self, forKey: .user)
        resId = try values.decodeIfPresent(Int.self, forKey: .resId) ?? 0
        caption = try values.decodeIfPresent(String.self, forKey: .caption) ?? ""
        timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp) ?? 0
        friendlyTime = try values.decodeIfPresent(String.self, forKey: .friendlyTime) ?? ""
        width = try values.decodeIfPresent(Int.self, forKey: .width) ?? 0
        height = try values.decodeIfPresent(Int.self, forKey: .height) ?? 0
    }
}
