//
//  RatingObj.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/19/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct RatingObj: Codable {
    let title: Title
    let bgColor: BgColor

    enum CodingKeys: String, CodingKey {
        case title
        case bgColor = "bg_color"
    }
}
