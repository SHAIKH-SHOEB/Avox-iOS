//
//  IBExtension.swift
//  Avox
//
//  Created by Shaikh Shoeb on 22/07/24.
//

import UIKit

@IBDesignable // Allows live rendering in Interface Builder
extension UIView {
    // Use @IBInspectable to make properties adjustable in Interface Builder
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
}
