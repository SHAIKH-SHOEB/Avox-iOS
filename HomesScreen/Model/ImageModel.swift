//
//  ImageModel.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit

class ImageModel: NSObject {
    
    var original : String?
    var large2x : String?
    var large : String?
    var medium : String?
    var small : String?
    var portrait : String?
    var landscape : String?
    var tiny : String?
    
    
    init(dictionary : [String : Any]) {
        super.init()
        original = dictionary["original"] as? String
        large2x = dictionary["large2x"] as? String
        large = dictionary["large"] as? String
        medium = dictionary["medium"] as? String
        small = dictionary["small"] as? String
        portrait = dictionary["portrait"] as? String
        landscape = dictionary["landscape"] as? String
        tiny = dictionary["tiny"] as? String
    }

}
