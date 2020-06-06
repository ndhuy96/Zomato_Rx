//
//  Photos.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

struct Photos: Codable {
    let photo: Photo

    enum CodingKeys: String, CodingKey {
        case photo
    }
}
