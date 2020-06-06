//
//  RestaurantDetail.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

struct RestaurantDetail: Codable {
    let restaurantInfo: RestaurantInfo
    let id: String
    let name: String
    let url: String
    let location: Location
    let switchToOrderMenu: Int
    let cuisines: String
    let timings: String
    let averageCostForTwo: Int
    let priceRange: Int
    let currency: String
    let highlights: [String]
    let offers: [String]
    let opentableSupport: Int
    let isZomatoBookRes: Int
    let mezzoProvider: String
    let isBookFormWebView: Int
    let bookFormWebViewUrl: String
    let bookAgainUrl: String
    let thumb: String
    let userRating: UserRating
    let allReviewsCount: Int
    let photosUrl: String
    let photoCount: Int
    let photos: [Photos]?
    let menuUrl: String
    let featuredImage: String
    let hasOnlineDelivery: Int
    let isDeliveringNow: Int
    let storeType: String
    let includeBogoOffers: Bool
    let deeplink: String
    let isTableReservationSupported: Int
    let hasTableBooking: Int
    let eventsUrl: String
    let phoneNumbers: String
    let allReviews: AllReviews
    let establishment: [String]

    enum CodingKeys: String, CodingKey {
        case restaurantInfo = "R"
        case id
        case name
        case url
        case location
        case switchToOrderMenu = "switch_to_order_menu"
        case cuisines
        case timings
        case averageCostForTwo = "average_cost_for_two"
        case priceRange = "price_range"
        case currency
        case highlights
        case offers
        case opentableSupport = "opentable_support"
        case isZomatoBookRes = "is_zomato_book_res"
        case mezzoProvider = "mezzo_provider"
        case isBookFormWebView = "is_book_form_web_view"
        case bookFormWebViewUrl = "book_form_web_view_url"
        case bookAgainUrl = "book_again_url"
        case thumb
        case userRating = "user_rating"
        case allReviewsCount = "all_reviews_count"
        case photosUrl = "photos_url"
        case photoCount = "photo_count"
        case photos
        case menuUrl = "menu_url"
        case featuredImage = "featured_image"
        case hasOnlineDelivery = "has_online_delivery"
        case isDeliveringNow = "is_delivering_now"
        case storeType = "store_type"
        case includeBogoOffers = "include_bogo_offers"
        case deeplink
        case isTableReservationSupported = "is_table_reservation_supported"
        case hasTableBooking = "has_table_booking"
        case eventsUrl = "events_url"
        case phoneNumbers = "phone_numbers"
        case allReviews = "all_reviews"
        case establishment
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        restaurantInfo = try values.decode(RestaurantInfo.self, forKey: .restaurantInfo)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        url = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
        location = try values.decode(Location.self, forKey: .location)
        switchToOrderMenu = try values.decodeIfPresent(Int.self, forKey: .switchToOrderMenu) ?? 0
        cuisines = try values.decodeIfPresent(String.self, forKey: .cuisines) ?? ""
        timings = try values.decodeIfPresent(String.self, forKey: .timings) ?? ""
        averageCostForTwo = try values.decodeIfPresent(Int.self, forKey: .averageCostForTwo) ?? 0
        priceRange = try values.decodeIfPresent(Int.self, forKey: .priceRange) ?? 0
        currency = try values.decodeIfPresent(String.self, forKey: .currency) ?? ""
        highlights = try values.decodeIfPresent([String].self, forKey: .highlights) ?? []
        offers = try values.decodeIfPresent([String].self, forKey: .offers) ?? []
        opentableSupport = try values.decodeIfPresent(Int.self, forKey: .opentableSupport) ?? 0
        isZomatoBookRes = try values.decodeIfPresent(Int.self, forKey: .isZomatoBookRes) ?? 0
        mezzoProvider = try values.decodeIfPresent(String.self, forKey: .mezzoProvider) ?? ""
        isBookFormWebView = try values.decodeIfPresent(Int.self, forKey: .isBookFormWebView) ?? 0
        bookFormWebViewUrl = try values.decodeIfPresent(String.self, forKey: .bookFormWebViewUrl) ?? ""
        bookAgainUrl = try values.decodeIfPresent(String.self, forKey: .bookAgainUrl) ?? ""
        thumb = try values.decodeIfPresent(String.self, forKey: .thumb) ?? ""
        userRating = try values.decode(UserRating.self, forKey: .userRating)
        allReviewsCount = try values.decodeIfPresent(Int.self, forKey: .allReviewsCount) ?? 0
        photosUrl = try values.decodeIfPresent(String.self, forKey: .photosUrl) ?? ""
        photoCount = try values.decodeIfPresent(Int.self, forKey: .photoCount) ?? 0
        photos = try? values.decode([Photos].self, forKey: .photos)
        menuUrl = try values.decodeIfPresent(String.self, forKey: .menuUrl) ?? ""
        featuredImage = try values.decodeIfPresent(String.self, forKey: .featuredImage) ?? ""
        hasOnlineDelivery = try values.decodeIfPresent(Int.self, forKey: .hasOnlineDelivery) ?? 0
        isDeliveringNow = try values.decodeIfPresent(Int.self, forKey: .isDeliveringNow) ?? 0
        storeType = try values.decodeIfPresent(String.self, forKey: .storeType) ?? ""
        includeBogoOffers = try values.decodeIfPresent(Bool.self, forKey: .includeBogoOffers) ?? false
        deeplink = try values.decodeIfPresent(String.self, forKey: .deeplink) ?? ""
        isTableReservationSupported = try values.decodeIfPresent(Int.self, forKey: .isTableReservationSupported) ?? 0
        hasTableBooking = try values.decodeIfPresent(Int.self, forKey: .hasTableBooking) ?? 0
        eventsUrl = try values.decodeIfPresent(String.self, forKey: .eventsUrl) ?? ""
        phoneNumbers = try values.decodeIfPresent(String.self, forKey: .phoneNumbers) ?? ""
        allReviews = try values.decode(AllReviews.self, forKey: .allReviews)
        establishment = try values.decodeIfPresent([String].self, forKey: .establishment) ?? []
    }
}
