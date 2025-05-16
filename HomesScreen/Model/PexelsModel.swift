//
//  PexelsModel.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit

class PexelsModel: NSObject {
    
    var id : Int?
    var width: Int?
    var height : Int?
    var url : String?
    var photographer : String?
    var photographer_url : String?
    var photographer_id : Int?
    var avg_color     : String?
    var src   : ImageModel?
    var liked   : Bool?
    var alt : String?
    
    override init() {
        super.init()
    }
    
    init(dictionary : [String : Any]) {
        super.init()
        id = dictionary["id"] as? Int
        width = dictionary["width"] as? Int
        height = dictionary["height"] as? Int
        url = dictionary["url"] as? String
        photographer = dictionary["photographer"] as? String
        photographer_url = dictionary["photographer_url"] as? String
        photographer_id = dictionary["photographer_id"] as? Int
        avg_color = dictionary["avg_color"] as? String
        
        if let srcDictionary = dictionary["src"] as? [String: Any] {
            src = ImageModel(dictionary: srcDictionary)
        }
        
        alt = dictionary["alt"] as? String
    }
}
