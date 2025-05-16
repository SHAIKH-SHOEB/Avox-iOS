//
//  DeviceManager.swift
//  Avox
//
//  Created by Shaikh Shoeb on 22/03/24.
//

//iPhone 6, iPhone 6s, iPhone 7, and iPhone 8:
//Screen Width: 375 points
//Screen Height: 667 points
//iPhone SE (1st generation):
//Screen Width: 320 points
//Screen Height: 568 points
//iPhone SE (2nd generation):
//Screen Width: 375 points
//Screen Height: 667 points

//iPhone 6 Plus, iPhone 6s Plus, iPhone 7 Plus, and iPhone 8 Plus:
//Screen Width: 414 points
//Screen Height: 736 points
//iPhone X, iPhone XS, iPhone 11 Pro, iPhone 12 Pro:
//Screen Width: 375 points
//Screen Height: 812 points
//iPhone 12, iPhone 12s, iPhone 13, iPhone 13s, iPhone 12 Pro, iPhone 12s Pro, iPhone 13 Pro, iPhone 13s Pro, iphone 14:
//Screen Width: 390 points
//Screen Height: 844 points

//iPhone XR, iPhone 11, iPhone XS Max, iPhone 11 Pro Max, iPhone 12 Pro Max:
//Screen Width: 414 points
//Screen Height: 896 points
//iPhone 12 Mini, iPhone 13 mini:
//Screen Width: 360 points
//Screen Height: 780 points

//iPhone 12 Pro Max, iPhone 12s Pro Max, iPhone 13 Pro Max, iPhone 13s Pro Max, iphone 14 plus:
//Screen Width: 428 points
//Screen Height: 926 points

// iPhone 14 Pro Max
//Screen Width: 426 points
//Screen Height: 932 points




//if screenWidth == 320.0 && screenHeight == 568.0 {
//    return .iPhone5
//} else if screenWidth == 375.0 && screenHeight == 667.0 {
//    return .iPhone6
//} else if screenWidth == 414.0 && screenHeight == 736.0 {
//    return .iPhone6plus
//} else if screenHeight >= 812.0 && UIDevice.current.hasNotch {
//    return .iPhoneXFamily
//} else if screenWidth >= 390.0 && screenHeight >= 844.0 {
//    return .iPhone12Family
//} else {
//    return .iPhone
//}


import UIKit

class DeviceManager: NSObject {
    
    var deviceOrientation   : Int = -1;
    var deviceType          : Int = -1;
    
    
    let iPhone              = 0
    let iPhone5             = 1
    let iPhone6             = 2
    let iPhone6plus         = 3
    let iPhoneX             = 4
    let iphone12Family      = 5
    let iphoneProMax        = 6
    let iPad                = 8
    let iPad_10_5           = 9
    let iPad_12_9           = 10

    let LANDSCAPE           =   1
    let POTRAIT             =   2
    
    let screenHeight        = UIScreen.main.bounds.size.height
    let screenWidth         = UIScreen.main.bounds.size.width
    let screenHeightFloat   : Float  = Float(UIScreen.main.bounds.size.height)
    let screenWidthFloat    : Float  = Float(UIScreen.main.bounds.size.width)
    
    
    //MARK: - It initializes class instance single time only with static property and it will allow to share class instance globally.
    static var instance : DeviceManager = {
        let deviceManagerInstance = DeviceManager()
        return deviceManagerInstance
    }()
    
    private override init() {
        super.init()
        
        deviceType = getDeviceType()
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let orientation = windowScene!.interfaceOrientation
        
        switch (orientation) {
        case .portrait:
            deviceOrientation   =   POTRAIT
        case .portraitUpsideDown:
            deviceOrientation   =   POTRAIT
        case .landscapeLeft:
            deviceOrientation   =   LANDSCAPE
        case .landscapeRight:
            deviceOrientation   =   LANDSCAPE
        default:
            deviceOrientation   =   POTRAIT
        }
    }
    
    
    func getDeviceType() -> Int {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if screenWidth == 834.0 && screenHeight == 1112.0 {
                return iPad_10_5;
            } else if screenWidth == 1024.0 && screenHeight == 1366.0 {
                return iPad_12_9;
            } else {
                return iPad;
            }
        } else {
            // combine iphone5 and iphone 6 while using it in screens
            if screenWidth == 320.0 && screenHeight == 568.0 {
                return iPhone5;
            } else if screenWidth == 375.0 && screenHeight == 667.0 {
                return iPhone6;
            } else if screenWidth == 414.0 && screenHeight == 736.0 {
                return iPhone6plus;
            } else if (screenWidth == 375.0 && screenHeight == 812.0) || (screenWidth == 360.0 && screenHeight == 780.0){
                return iPhoneX;
            } else if screenWidth >= 390 && screenHeight <= 860 {
                return iphone12Family;
            } else if screenWidth == 414 && screenHeight == 896 {
                return iphoneProMax;
            } else {
                return iPhone;
            }
        }
    }
    
    class func sharedDeviceManagement() -> DeviceManager! {
        return instance
    }
}


//class DeviceManager {
//    
//    static let shared = DeviceManager()
//    
//    private init() {}
//    
//    //MARK: For FontSize
//    var fontSize: CGFloat {
//        let deviceModel = UIDevice.current.name
//        let screenType = ScreenType(deviceModel: deviceModel)
//        
//        switch screenType {
//        case .small:
//            return 12.0
//        case .medium:
//            return 13.0
//        case .large:
//            return 14.0
//        case .default:
//            return 13.0
//        }
//    }
//    
//    //MARK: For Constant
//    var constant: CGFloat {
//        let deviceModel = UIDevice.current.name
//        let screenType = ScreenType(deviceModel: deviceModel)
//        
//        switch screenType {
//        case .small:
//            return 6.0
//        case .medium:
//            return 8.0
//        case .large:
//            return 10.0
//        case .default:
//            return 8.0
//        }
//    }
//    
//    //MARK: For CellHeight
//    var cellHeight: CGFloat {
//        let deviceModel = UIDevice.current.name
//        let screenType = ScreenType(deviceModel: deviceModel)
//        
//        switch screenType {
//        case .small:
//            return 46.0
//        case .medium:
//            return 50.0
//        case .large:
//            return 56.0
//        case .default:
//            return 50.0
//        }
//    }
//    
//    //MARK: For viewHeight
//    var viewHeight: CGFloat {
//        let deviceModel = UIDevice.current.name
//        let screenType = ScreenType(deviceModel: deviceModel)
//        
//        switch screenType {
//        case .small:
//            return 38.0
//        case .medium:
//            return 46.0
//        case .large:
//            return 50.0
//        case .default:
//            return 46.0
//        }
//    }
//}
//
//enum ScreenType {
//    case small
//    case medium
//    case large
//    case `default` // Use backticks for `default` as it's a reserved keyword
//    
//    init(deviceModel: String) {
//        switch deviceModel {
//        case "iPhone SE (3rd generation)", "iPhone SE (2rd generation)", "iPhone 8", "iPhone 7", "iPhone 6", "iPhone 6s", "iPhone SE (1st generation)":
//            self = .small
//        case "iPhone 13 Mini", "iPhone 12 Mini", "iPhone 8 Plus", "iPhone 7 Plus", "iPhone 6s Plus":
//            self = .medium
//        case "iPhone 11 Pro", "iPhone 11", "iPhone XS", "iPhone Xʀ", "iPhone X", "iPhone 15 Pro Max", "iPhone 15 Pro", "iPhone 15 Plus", "iPhone 15", "iPhone 14 Pro Max", "iPhone 14 Pro", "iPhone 14 Plus", "iPhone 14", "iPhone 13 Pro Max", "iPhone 13 Pro", "iPhone 13", "iPhone 12 Pro Max", "iPhone 12 Pro", "iPhone 12", "iPhone 11 Pro Max", "iPhone XS Max":
//            self = .large
//        default:
//            self = .default // Use `.default` instead of `.defaults`
//        }
//    }
//}
