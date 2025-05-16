//
//  Helper.swift
//  Avox
//
//  Created by Shaikh Shoeb on 22/03/24.
//

import UIKit
import Foundation

struct Helper {
    struct Color {
        static let accent        = UIColor(named: "AccentColor")
        static let bgPrimary     = UIColor(named: "BGPrimaryColor")
        static let bgSecondary   = UIColor(named: "BGSecondaryColor")
        static let textPrimary   = UIColor(named: "TextPrimaryColor")
        static let textSecondary = UIColor(named: "TextSecondaryColor")
        static let appPrimary    = UIColor(named: "AppPrimaryColor")
        static let appSecondary  = UIColor(named: "AppSecondaryColor")
        static let apple         = UIColor(named: "AppleColor")
        static let google        = UIColor(named: "GoogleColor")
    }
    
    struct DeviceManager {
        static let IPHONE_5_6_CONSTANT             : CGFloat = 6.0
        static let IPHONE_5_6_FONT_SIZE            : CGFloat = 14.0
        static let IPHONE_5_6_CELL_HEIGHT          : CGFloat = 48.0
        static let IPHONE_5_6_CONTAINER_HEIGHT     : CGFloat = 76.0
        
        static let IPHONE_6PLUS_X_CONSTANT         : CGFloat = 8.0
        static let IPHONE_6PLUS_X_FONT_SIZE        : CGFloat = 15.0
        static let IPHONE_6PLUS_X_CELL_HEIGHT      : CGFloat = 50.0
        static let IPHONE_6PLUS_X_CONTAINER_HEIGHT : CGFloat = 80.0
        
        static let IPHONE_12FAMILY_CONSTANT        : CGFloat = 10.0
        static let IPHONE_12FAMILY_FONT_SIZE       : CGFloat = 16.0
        static let IPHONE_12FAMILY_CELL_HEIGHT     : CGFloat = 52.0
        static let IPHONE_12FAMILY_CONTAINER_HEIGHT: CGFloat = 84.0
        
        static let IPHONE_CONSTANT                 : CGFloat = 12.0
        static let IPHONE_FONT_SIZE                : CGFloat = 17.0
        static let IPHONE_CELL_HEIGHT              : CGFloat = 58.0
        static let IPHONE_CONTAINER_HEIGHT         : CGFloat = 90.0
    }
    
    struct Message {
        static var somethingWentWrong = "Something Went Wrong"
    }
    
    //For App Preference
    static var isAppMode: String {
        return UserDefaults.standard.string(forKey: AppConstants.APP_MODE) ?? ""
    }
    
    static var isPassCode: Int {
        return UserDefaults.standard.integer(forKey: AppConstants.PASS_CODE)
    }
    
    static var isAppLock: Bool {
        return UserDefaults.standard.bool(forKey: AppConstants.APP_LOCK)
    }
    
    static var isSelectLanguage: String {
        return UserDefaults.standard.string(forKey: AppConstants.LANGUAGE_KEY) ?? "en"
    }
    
    static var isRegistration: Bool {
        return UserDefaults.standard.bool(forKey: AppConstants.IS_REGISTRATION)
    }
}
