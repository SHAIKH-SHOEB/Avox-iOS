//
//  AppUtilities.swift
//  Avox
//
//  Created by Shaikh Shoeb on 04/08/24.
//

import UIKit
import Foundation

class AppUtilities: NSObject {
    class func sizeOfString (string: String, constrainedToWidth width: Double, forFont font: UIFont) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                        options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
}
