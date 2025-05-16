//
//  AppConstants.swift
//  Avox
//
//  Created by Shaikh Shoeb on 22/03/24.
//

import UIKit

class AppConstants: NSObject {
    
    static var APP_LOCK = "AppLock"
    static var APP_MODE = "AppMode"
    static var PASS_CODE = "PassCode"
    static var LANGUAGE_KEY = "LanguageKey"
    static var IS_REGISTRATION = "IsRegistration"
    
    static var searchSuggestionModel = ["Nature", "Forest", "Mountains", "Beach", "Sunset", "Waterfall", "Animals", "Cats", "Dogs", "Birds", "Tigers", "Wolves", "Abstract", "Geometric", "Patterns", "Minimalist", "Colorful", "Gradients", "Space", "Planets", "Stars", "Galaxies", "Nebulae", "Astronauts", "Seasons", "Summer", "Autumn", "Winter", "Spring", "Cities", "New York", "Paris", "Tokyo", "London", "Dubai", "Fantasy", "Dragons", "Elves", "Wizards", "Castles", "Fairies", "Technology", "Computers", "Smartphones", "Robots", "Circuitry", "Futuristic"]
    
    enum LanguageCode : String {
        case banglaKey = "bn-IN"
        case englishKey = "en"
        case gujaratiKey = "gu-IN"
        case hindiKey = "hi"
        case marathiKey = "mr-IN"
        case tamilKey = "ta-IN"
        case teluguKey = "te-IN"
        case urduKey = "ur"
    }
    
    #if Avox
    static var NAME = "Avox"
    static var APP_VERSION = "1.0"
    #elseif Vavox
    static var NAME = "Vavox"
    static var APP_VERSION = "1.0"
    #else
    static var NAME = "Softy"
    static var APP_VERSION = "1.0"
    #endif
    
    class func isAvoxBuild() -> Bool{
        var result : Bool = false
        #if Avox
        result = true
        #else
        result = false
        #endif
        return result
    }
    
    class func isVavoxBuild() -> Bool{
        var result : Bool = false
        #if Vavox
        result = true
        #else
        result = false
        #endif
        return result
    }
    
    class func isDebugBuild() -> Bool {
        var result : Bool = false
        #if DEBUG
        result = true
        #elseif RELEASE
        retult = false
        #else
        result = false
        #endif
        return result
    }
    
    class func isOSType() -> String {
        var type : String = ""
        #if os(iOS)
        type = "iOS"
        #elseif os(macOS)
        type = "macOS"
        #elseif os(tvOS)
        type = "tvOS"
        #elseif os(watchOS)
        type = "watchOS"
        #else
        type = "Unknown"
        #endif
        return type
    }
    
    class func isArm64() -> Bool {
        var result : Bool = false
        #if arch(arm64)
        result = true
        #elseif arch(x86_64)
        result = false
        #else
        result = false
        #endif
        return result
    }
}
