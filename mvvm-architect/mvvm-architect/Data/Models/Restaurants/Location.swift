//
//  Location.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/19/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct Location: Codable {
    let address: String
    let locality: String
    let city: String
    let cityId: Int
    let latitude: String
    let longitude: String
    let zipcode: String
    let countryId: Int
    let localityVerbose: String

    enum CodingKeys: String, CodingKey {
        case address
        case locality
        case city
        case cityId = "city_id"
        case latitude
        case longitude
        case zipcode
        case countryId = "country_id"
        case localityVerbose = "locality_verbose"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
        locality = try values.decodeIfPresent(String.self, forKey: .locality) ?? ""
        city = try values.decodeIfPresent(String.self, forKey: .city) ?? ""
        cityId = try values.decodeIfPresent(Int.self, forKey: .cityId) ?? 0
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude) ?? ""
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude) ?? ""
        zipcode = try values.decodeIfPresent(String.self, forKey: .zipcode) ?? ""
        countryId = try values.decodeIfPresent(Int.self, forKey: .countryId) ?? 0
        localityVerbose = try values.decodeIfPresent(String.self, forKey: .localityVerbose) ?? ""
    }
}
