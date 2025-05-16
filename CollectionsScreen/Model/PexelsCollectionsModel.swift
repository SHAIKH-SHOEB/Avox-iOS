//
//  PexelsCollectionsModel.swift
//  Avox
//
//  Created by Shaikh Shoeb on 17/09/24.
//

import Foundation

struct PexelsCollectionsModel: Codable {
    let page: Int
    let perPage: Int
    let collections: [Collections]
    let totalResults: Int
    let nextPage: String?

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case collections
        case totalResults = "total_results"
        case nextPage = "next_page"
    }
}

struct Collections: Codable {
    let id: String
    let title: String
    let description: String?
    let isPrivate: Bool
    let mediaCount: Int
    let photosCount: Int
    let videosCount: Int
    var isExpanded = true

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case isPrivate = "private"
        case mediaCount = "media_count"
        case photosCount = "photos_count"
        case videosCount = "videos_count"
    }
}
