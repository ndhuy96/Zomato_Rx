//
//  RatingObj.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

struct RatingObj: Codable {
    let title: Title
    let bgColor: BgColor

    enum CodingKeys: String, CodingKey {
        case title
        case bgColor = "bg_color"
    }
}
