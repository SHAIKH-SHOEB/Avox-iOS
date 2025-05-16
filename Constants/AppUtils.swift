//
//  AppUtils.swift
//  Avox
//
//  Created by Nimap on 17/02/24.
//

import UIKit
import Network
import AudioToolbox

class AppUtils: NSObject {
    class func applyShadowOnView(view: UIView) {
        view.layer.shadowColor = Helper.Color.textSecondary!.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
    }
    
    class func applyShadowOnImage(imageView: UIImageView) {
        imageView.layer.shadowColor = Helper.Color.textSecondary!.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        imageView.layer.shadowRadius = 2
    }
    
    class func applyBorderOnView(view: UIView, radius: CGFloat) {
        view.layer.borderColor = Helper.Color.textSecondary?.cgColor
        view.layer.borderWidth = 0.3
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
    }
    
    class func applyBorderOnImage(image: UIImageView, radius: CGFloat) {
        image.layer.borderColor = Helper.Color.textSecondary?.cgColor
        image.layer.borderWidth = 0.5
        image.layer.cornerRadius = radius
        image.layer.masksToBounds = true
    }
    
    class func iOSVersionFamily () -> Float {
        //we don't want exact version but want to check iOS 6,7 or 8 thus using
        let floatVersion = (UIDevice.current.systemVersion as NSString).floatValue
        return floatVersion
    }
    
    class func dateToDateFormatAsString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func dateToTimeFormatAsString(date: Date) -> String {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "hh:mm a"
        let dateTimeString = dateTimeFormatter.string(from: date)
        return dateTimeString
    }
    
    class func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM" // "EEEE" for full day name, "dd" for day of month, "MMMM" for full month name
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }
    
    class func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a" // "h" for 12-hour format, "mm" for minutes, "a" for AM/PM
        let timeString = dateFormatter.string(from: Date())
        return timeString
    }
    
    class func setNickName() -> String {
        var name = ""
        if UserDefaults.standard.string(forKey: "nickName") != "" {
            name = UserDefaults.standard.string(forKey: "nickName")!
        }else {
            name = AppConstants.NAME
        }
        return name
    }
    
    class func setEmailID() -> String {
        var email = ""
        if UserDefaults.standard.string(forKey: "email") != "" {
            email = UserDefaults.standard.string(forKey: "email")!
        }else {
            email = AppConstants.isAvoxBuild() ? "avox@gmail.com" : "vavox@gmail.com"
        }
        return email
    }
    
    class func generateRandomNumber() -> Int {
        let randomNumber = Int(arc4random_uniform(900000) + 100000)
        UserDefaults.standard.set(randomNumber, forKey: "OTP")
        return randomNumber
    }
    
    class func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    class func modelName(for identifier: String) -> String {
        switch identifier {
        case "iPhone13,2": return "iPhone 12 Pro"
        case "iPhone13,3": return "iPhone 12 Pro Max"
        case "iPhone14,2": return "iPhone 13 Pro"
        // Add more mappings here.
        default: return identifier // For unidentified or new models, return the identifier.
        }
    }
    
    class func checkAppVersion() -> Bool {
        let dictionary  = Bundle.main.infoDictionary!
        let version     = dictionary["CFBundleShortVersionString"] as! String
        print(version)
        if Float(version)! < Float(AppConstants.APP_VERSION)! {
            return true
        }else {
            return false
        }
    }
    
    class func calculateWidth(labelcontent : String!, width : CGFloat, fontSize : CGFloat, isFontBold : Bool) -> CGFloat {
        let dummylabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: width, height: UIScreen.main.bounds.size.height))
        dummylabel.numberOfLines = 1
        if isFontBold
        {
            dummylabel.font = UIFont.appFontBold(ofSize: fontSize)
        }else{
            dummylabel.font = UIFont.appFontRegular(ofSize: fontSize)
        }
        dummylabel.text = labelcontent
        dummylabel.sizeToFit()
        
        if labelcontent.lowercased() != "na" {
            return dummylabel.frame.size.width
        }else{
            return 1.0
        }
    }
    
    class func localizableString(key: String) -> String {
        let path = Bundle.main.path(forResource: Helper.isSelectLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    class func randomColors(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = CGFloat(arc4random_uniform(256)) / 255.0
            let green = CGFloat(arc4random_uniform(256)) / 255.0
            let blue = CGFloat(arc4random_uniform(256)) / 255.0
            let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            colors.append(color)
        }
        return colors
    }
    
    class func isRegistration() -> Bool {
        return UserDefaults.standard.bool(forKey: "isRegistration") ? true : false
    }
    
    class func getSelectedLanguage() -> String {
        switch Helper.isSelectLanguage {
        case AppConstants.LanguageCode.banglaKey.rawValue:
            return "(বাংলা)"
        case AppConstants.LanguageCode.englishKey.rawValue:
            return "(English)"
        case AppConstants.LanguageCode.gujaratiKey.rawValue:
            return "(ગુજરાતી)"
        case AppConstants.LanguageCode.hindiKey.rawValue:
            return "(हिंदी)"
        case AppConstants.LanguageCode.marathiKey.rawValue:
            return "(मराठी)"
        case AppConstants.LanguageCode.tamilKey.rawValue:
            return "(தமிழ்)"
        case AppConstants.LanguageCode.teluguKey.rawValue:
            return "(తెలుగు)"
        case AppConstants.LanguageCode.urduKey.rawValue:
            return "(اردو)"
        default:
            return "en"
        }
    }
    
    //MARK: This Class Using For Device Vibrate Onclick Button
    class func vibrateDevice() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    class func copyTextToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }
    
    class func getCopiedText() -> String? {
        return UIPasteboard.general.string
    }
    
    class func getNetworkType() -> String {
        var type = ""
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.usesInterfaceType(.wifi) {
                type = "wifi"
            }else if path.usesInterfaceType(.cellular) {
                type = "network"
            }else if path.usesInterfaceType(.loopback) {
                type = "internaldrive"
            }else if path.usesInterfaceType(.wiredEthernet) {
                type = "cable.connector"
            }else if path.usesInterfaceType(.other) {
                type = "network.slash"
            }
        }
        return type
    }
}

//priceType.caseInsensitiveCompare("MRP") == .orderedSame
