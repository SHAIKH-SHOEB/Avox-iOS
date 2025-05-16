//
//  UIFont+AppFont.swift
//  WallGems
//
//  Created by Shaikh Shoeb on 06/07/24.
//

import UIKit

extension UIFont {
    class func appFontLight(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-Light", size: ofSize)
    }
    
    class func appFontRegular(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-Regular", size: ofSize)
    }
    
    class func appFontMedium(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-Medium", size: ofSize)
    }
    
    class func appFontBold(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-Bold", size: ofSize)
    }
    
    class func appFontExtraBold(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-ExtraBold", size: ofSize)
    }
    
    class func appFontItalic(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-Italic", size: ofSize)
    }
}
