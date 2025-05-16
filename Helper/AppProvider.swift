//
//  AppProvider.swift
//  Avox
//
//  Created by Nimap on 11/03/24.
//

import UIKit

class AppProvider: NSObject {
    
    var id        : Int?
    var title     : String?
    var index     : Int?
    var icon      : String?
    var value     : String?
    var cellWidth : CGFloat?
    
    static func getImageTypeTitleProvider() -> [AppProvider] {
        var models = [AppProvider]()
        
        let model1 = AppProvider()
        model1.id = 1
        model1.title = "Mountain"
        model1.icon = AppUtils.localizableString(key: LanguageConstant.mountain)
        model1.index = 0
        models.append(model1)
        
        let model2 = AppProvider()
        model2.id = 2
        model2.title = "Nature"
        model2.icon = AppUtils.localizableString(key: LanguageConstant.nature)
        model2.index = 0
        models.append(model2)
        
        let model3 = AppProvider()
        model3.id = 3
        model3.title = "Kolkata"
        model3.icon = AppUtils.localizableString(key: LanguageConstant.kolkata)
        model3.index = 0
        models.append(model3)
        
        let model4 = AppProvider()
        model4.id = 4
        model4.title = "Ocean"
        model4.icon = AppUtils.localizableString(key: LanguageConstant.ocean)
        model4.index = 0
        models.append(model4)
        
        let model5 = AppProvider()
        model5.id = 5
        model5.title = "Wallpaper"
        model5.icon = AppUtils.localizableString(key: LanguageConstant.wallpaper)
        model5.index = 0
        models.append(model5)
        
        let model6 = AppProvider()
        model6.id = 6
        model6.title = "Flower"
        model6.icon = AppUtils.localizableString(key: LanguageConstant.flower)
        model6.index = 0
        models.append(model6)
        
        let model7 = AppProvider()
        model7.id = 7
        model7.title = "Beauty"
        model7.icon = AppUtils.localizableString(key: LanguageConstant.beauty)
        model7.index = 0
        models.append(model7)
        
        let model8 = AppProvider()
        model8.id = 8
        model8.title = "Computer"
        model8.icon = AppUtils.localizableString(key: LanguageConstant.computer)
        model8.index = 0
        models.append(model8)
        
        let model9 = AppProvider()
        model9.id = 9
        model9.title = "Persons"
        model9.icon = AppUtils.localizableString(key: LanguageConstant.person)
        model9.index = 0
        models.append(model9)
        
        let model10 = AppProvider()
        model10.id = 10
        model10.title = "Masjid"
        model10.icon = AppUtils.localizableString(key: LanguageConstant.masjid)
        model10.index = 0
        models.append(model10)
        
        // Sorting the models array by title
        models.sort { $0.title! < $1.title! }
        
        for each in models {
            each.cellWidth = AppUtils.calculateWidth(labelcontent: each.icon, width: 9999, fontSize: 20, isFontBold: false)
        }
        
        return models
    }
    
    static func getSettingsTitleProvider() -> [AppProvider] {
        var models = [AppProvider]()
        
        let model1 = AppProvider()
        model1.id = 1
        model1.title = LanguageConstant.history
        model1.index = nil
        model1.icon = "clock.arrow.circlepath"
        models.append(model1)
        
        let model2 = AppProvider()
        model2.id = 2
        model2.title = LanguageConstant.collections
        model2.index = nil
        model2.icon = "rectangle.3.group"
        models.append(model2)
        
        let model3 = AppProvider()
        model3.id = 3
        model3.title = LanguageConstant.suggestion
        model3.index = nil
        model3.icon = "mappin.and.ellipse.circle"
        models.append(model3)
        
        let model4 = AppProvider()
        model4.id = 4
        model4.title = LanguageConstant.language
        model4.index = nil
        model4.icon = "globe"
        models.append(model4)
        
        let model5 = AppProvider()
        model5.id = 5
        model5.title = LanguageConstant.darkMode
        model5.index = 1
        model5.icon = "moon"
        models.append(model5)
        
        let model6 = AppProvider()
        model6.id = 6
        model6.title = LanguageConstant.pushNotification
        model6.index = 1
        model6.icon = "bell.and.waves.left.and.right"
        models.append(model6)
        
        let model7 = AppProvider()
        model7.id = 7
        model7.title = LanguageConstant.preference
        model7.index = nil
        model7.icon = "infinity.circle"
        models.append(model7)
        
        let model8 = AppProvider()
        model8.id = 8
        model8.title = LanguageConstant.termServices
        model8.index = nil
        model8.icon = "book.pages"
        models.append(model8)
        
        let model9 = AppProvider()
        model9.id = 9
        model9.title = LanguageConstant.aboutUs
        model9.index = nil
        model9.icon = "exclamationmark.square"
        models.append(model9)
        
        return models
    }
    
    static func getLanguageProvider() -> [AppProvider] {
        var models = [AppProvider]()
        
        let model1 = AppProvider()
        model1.id = 1
        model1.title = "বাংলা"
        model1.value = "(বাংলা)"
        model1.index = 0
        model1.icon = "square"
        models.append(model1)
        
        let model2 = AppProvider()
        model2.id = 2
        model2.title = "English"
        model2.value = "(English)"
        model2.index = 1
        model2.icon = "square"
        models.append(model2)
        
        let model3 = AppProvider()
        model3.id = 3
        model3.title = "ગુજરાતી"
        model3.value = "(ગુજરાતી)"
        model3.index = 2
        model3.icon = "square"
        models.append(model3)
        
        let model4 = AppProvider()
        model4.id = 4
        model4.title = "हिंदी"
        model4.value = "(हिंदी)"
        model4.index = 3
        model4.icon = "square"
        models.append(model4)
        
        let model5 = AppProvider()
        model5.id = 5
        model5.title = "मराठी"
        model5.value = "(मराठी)"
        model5.index = 4
        model5.icon = "square"
        models.append(model5)
        
        let model6 = AppProvider()
        model6.id = 6
        model6.title = "தமிழ்"
        model6.value = "(தமிழ்)"
        model6.index = 5
        model6.icon = "square"
        models.append(model6)
        
        let model7 = AppProvider()
        model7.id = 7
        model7.title = "తెలుగు"
        model7.value = "(తెలుగు)"
        model7.index = 6
        model7.icon = "square"
        models.append(model7)
        
        let model8 = AppProvider()
        model8.id = 8
        model8.title = "اردو"
        model8.value = "(اردو)"
        model8.index = 7
        model8.icon = "square"
        models.append(model8)
        
        return models
    }
    
    static func getOnboardingProvider() -> [AppProvider] {
        var models = [AppProvider]()
        
        let model1 = AppProvider()
        model1.id = 1
        model1.title = LanguageConstant.onboardingOneTitle
        model1.index = 0
        model1.icon = "Onboardingf"
        model1.value = LanguageConstant.onboardingOneValue
        models.append(model1)
        
        let model2 = AppProvider()
        model2.id = 2
        model2.title = LanguageConstant.onboardingTwoTitle
        model2.index = 1
        model2.icon = "Onboardings"
        model2.value = LanguageConstant.onboardingTwoValue
        models.append(model2)
        
        let model3 = AppProvider()
        model3.id = 3
        model3.title = LanguageConstant.onboardingThreeTitle
        model3.index = 2
        model3.icon = "Onboardingt"
        model3.value = LanguageConstant.onboardingThreeValue
        models.append(model3)
        
        return models
    }
    
    static func getOptionProvider() -> [AppProvider] {
        var models = [AppProvider]()
        
        let model1 = AppProvider()
        model1.id = 1
        model1.title = LanguageConstant.profile
        model1.index = 0
        model1.icon = "person.crop.circle"
        models.append(model1)
        
        let model2 = AppProvider()
        model2.id = 2
        model2.title = LanguageConstant.downloadImage
        model2.index = 1
        model2.icon = "square.and.arrow.down"
        models.append(model2)
        
        let model3 = AppProvider()
        model3.id = 3
        model3.title = LanguageConstant.openImage
        model3.index = 2
        model3.icon = "photo"
        models.append(model3)
        
        return models
    }
    
    static func getAvatarProvider(gender: String? = nil) -> [AppProvider] {
        var models = [AppProvider]()
        let genders = gender != nil ? [gender!] : ["Man", "Woman"]
        
        for gender in genders {
            for index in 0..<10 {
                let model = AppProvider()
                model.id = genders.firstIndex(of: gender)!
                model.icon = "\(gender)Avatar\(index)"
                model.index = index
                models.append(model)
            }
        }
        return models
    }
    
    static func getSubscriptionProvider() -> [AppProvider] {
        var models = [AppProvider]()
        
        let model1 = AppProvider()
        model1.id = 1
        model1.index = 0
        model1.title = "$99.98 / year"
        model1.value = "•  Billed and recurring"
        model1.icon = "yearly"
        models.append(model1)
        
        let model2 = AppProvider()
        model2.id = 2
        model2.index = 0
        model2.title = "$29.98 / 3 months"
        model2.value = "•  Billed and recurring every"
        model2.icon = "3 months"
        models.append(model2)
        
        let model3 = AppProvider()
        model3.id = 3
        model3.index = 0
        model3.title = "$9.98 / month"
        model3.value = "•  Billed and recurring"
        model3.icon = "monthly"
        models.append(model3)
        
        //let model4 = AppProvider()
        //model4.id = 4
        //model4.title = "Enable Free Trial"
        //model4.value = ""
        //model4.icon = ""
        //models.append(model4)
        
        return models
    }
    
    static func getApplicationIconProvider() -> [AppProvider] {
        var models = [AppProvider]()
        
        let model1 = AppProvider()
        model1.id = 1
        model1.index = 0
        model1.icon = "AppIcon-1"
        model1.title = "Default"
        model1.value = "AppIcon"
        models.append(model1)
        
        let model2 = AppProvider()
        model2.id = 2
        model2.index = 0
        model2.icon = "AppIcon-2"
        model2.title = "Dark Mode"
        model2.value = "AppIconDark"
        models.append(model2)
        
        let model3 = AppProvider()
        model3.id = 3
        model3.index = 0
        model3.icon = "AppIcon-3"
        model3.title = "Special Event"
        model3.value = "AppIconEvent"
        models.append(model3)
        
        let model4 = AppProvider()
        model4.id = 4
        model4.index = 0
        model4.icon = "AppIcon-4"
        model4.title = "Special Day"
        model4.value = "AppIconDay"
        models.append(model4)
        
        return models
    }
}
