//
//  PexelsVideoModel.swift
//  Avox
//
//  Created by Nimap on 26/02/24.
//

import UIKit

struct PexelsVideoModel: Decodable {
    var page : Int?
    var per_page : Int?
    var videos : [Videos]?
    var total_results : Int?
    var next_page : String?
    var url : String
}

struct Videos: Decodable {
    var id : Int?
    var width : Int?
    var height : Int?
    var duration : Int?
    var full_res : String?
    var tags : [String]?
    var url : String?
    var image : String?
    var avg_color : String?
    var user : User?
    var video_files : [VideoFiles]?
    var video_pictures : [VideoPictures]?
}

struct User: Decodable {
    var id : Int?
    var name : String?
    var url : String?
}

struct VideoFiles: Decodable {
    var id : Int?
    var quality : String?
    var file_type : String?
    var width : Int?
    var height : Int?
    var fps : Double?
    var link : String?
}

struct VideoPictures: Decodable {
    var id : Int?
    var nr : Int?
    var picture : String?
}
