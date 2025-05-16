//
//  CollectionsDetailModel.swift
//  Avox
//
//  Created by Shaikh Shoeb on 21/09/24.
//

import Foundation

struct CollectionsDetailModel: Codable {
    let page, perPage: Int
    let media: [Media]
    let totalResults: Int
    let nextPage: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case media
        case totalResults = "total_results"
        case nextPage = "next_page"
        case id
    }
}

struct Media: Codable {
    let type: MediaType
    let id, width, height: Int
    let url: String
    let photographer: String?
    let photographerURL: String?
    let photographerID: Int?
    let avgColor: String?
    let src: Src?
    let liked: Bool?
    let alt: String?
    let duration: Int?
    let tags: [String]?
    let image: String?
    let user: Users?
    let videoFiles: [VideoFile]?
    let videoPictures: [VideoPicture]?

    enum CodingKeys: String, CodingKey {
        case type, id, width, height, url, photographer
        case photographerURL = "photographer_url"
        case photographerID = "photographer_id"
        case avgColor = "avg_color"
        case src, liked, alt, duration, tags, image, user
        case videoFiles = "video_files"
        case videoPictures = "video_pictures"
    }
}

struct Src: Codable {
    let original, large2X, large, medium: String
    let small, portrait, landscape, tiny: String

    enum CodingKeys: String, CodingKey {
        case original
        case large2X = "large2x"
        case large, medium, small, portrait, landscape, tiny
    }
}

enum MediaType: String, Codable {
    case photo = "Photo"
    case video = "Video"
}

struct Users: Codable {
    let id: Int
    let name: String
    let url: String
}

struct VideoFile: Codable {
    let id: Int
    let quality, fileType: String
    let width, height, fps: Int
    let link: String
    let size: Int

    enum CodingKeys: String, CodingKey {
        case id, quality
        case fileType = "file_type"
        case width, height, fps, link, size
    }
}

struct VideoPicture: Codable {
    let id, nr: Int
    let picture: String
}
