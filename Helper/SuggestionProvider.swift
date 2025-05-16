//
//  SuggestionProvider.swift
//  Avox
//
//  Created by Nimap on 03/03/24.
//

import UIKit

class SuggestionProvider: NSObject {

    var id : Int?
    var image : String?
    var title : String?
    var subTitle : String?
    var latitude : String?
    var longitude : String?
    var airport : String?
    var railway : String?
    var city : String?
    var about : String?
    
    static func getSuggestionProvider() -> [SuggestionProvider] {
        var models = [SuggestionProvider]()
        
        let model1 = SuggestionProvider()
        model1.id = 101
        model1.image = "https://i.postimg.cc/3Nzg1DyB/Taj-Mahal-F.jpg"
        model1.title = LanguageConstant.suggestionOneTitle
        model1.subTitle = LanguageConstant.suggestionOneSubTitle
        model1.latitude = "27.175335666904726"
        model1.longitude = "78.0420992806909"
        model1.airport = LanguageConstant.suggestionOneAirport
        model1.railway = LanguageConstant.suggestionOneRailway
        model1.city = LanguageConstant.suggestionOneCity
        model1.about = LanguageConstant.suggestionOneAbout
        models.append(model1)
        
        let model2 = SuggestionProvider()
        model2.id = 102
        model2.image = "https://i.postimg.cc/YSQyWMsZ/Ladakh.jpg"
        model2.title = LanguageConstant.suggestionTwoTitle
        model2.subTitle = LanguageConstant.suggestionTwoSubTitle
        model2.latitude = "34.15139019662094"
        model2.longitude = "77.57461027257143"
        model2.airport = LanguageConstant.suggestionTwoAirport
        model2.railway = LanguageConstant.suggestionTwoRailway
        model2.city = LanguageConstant.suggestionTwoCity
        model2.about = LanguageConstant.suggestionTwoAbout
        models.append(model2)
        
        let model3 = SuggestionProvider()
        model3.id = 103
        model3.image = "https://i.postimg.cc/g2nCn9db/Gulmarg.jpg"
        model3.title = LanguageConstant.suggestionThreeTitle
        model3.subTitle = LanguageConstant.suggestionThreeSubTitle
        model3.latitude = "34.04832337034914"
        model3.longitude = "74.38093746574091"
        model3.airport = LanguageConstant.suggestionThreeAirport
        model3.railway = LanguageConstant.suggestionThreeRailway
        model3.city = LanguageConstant.suggestionThreeCity
        model3.about = LanguageConstant.suggestionThreeAbout
        models.append(model3)
        
        let model4 = SuggestionProvider()
        model4.id = 104
        model4.image = "https://i.postimg.cc/mDffvmvf/Christ-Church.jpg"
        model4.title = LanguageConstant.suggestionFourTitle
        model4.subTitle = LanguageConstant.suggestionFourSubTitle
        model4.latitude = "31.103938164568895"
        model4.longitude = "77.17155159594301"
        model4.airport = LanguageConstant.suggestionFourAirport
        model4.railway = LanguageConstant.suggestionFourRailway
        model4.city = LanguageConstant.suggestionFourCity
        model4.about = LanguageConstant.suggestionFourAbout
        models.append(model4)
        
        let model5 = SuggestionProvider()
        model5.id = 105
        model5.image = "https://i.postimg.cc/y60Y8Zjy/Alappuzha.jpg"
        model5.title = LanguageConstant.suggestionFiveTitle
        model5.subTitle = LanguageConstant.suggestionFiveSubTitle
        model5.latitude = "9.498318176627038"
        model5.longitude = "76.34278826552588"
        model5.airport = LanguageConstant.suggestionFiveAirport
        model5.railway = LanguageConstant.suggestionFiveRailway
        model5.city = LanguageConstant.suggestionFiveCity
        model5.about = LanguageConstant.suggestionFiveAbout
        models.append(model5)
        
        let model6 = SuggestionProvider()
        model6.id = 106
        model6.image = "https://i.postimg.cc/T2tNmktd/Lakshadweep.jpg"
        model6.title = LanguageConstant.suggestionSixTitle
        model6.subTitle = LanguageConstant.suggestionSixSubTitle
        model6.latitude = "10.564718203800997"
        model6.longitude = "72.64154767216091"
        model6.airport = LanguageConstant.suggestionSixAirport
        model6.railway = LanguageConstant.suggestionSixRailway
        model6.city = LanguageConstant.suggestionSixCity
        model6.about = LanguageConstant.suggestionSixAbout
        models.append(model6)
        
        let model7 = SuggestionProvider()
        model7.id = 107
        model7.image = "https://i.postimg.cc/QMqJDtP8/istockphoto-620960858-612x612.jpg"
        model7.title = LanguageConstant.suggestionSevenTitle
        model7.subTitle = LanguageConstant.suggestionSevenSubTitle
        model7.latitude = "27.306602717620365"
        model7.longitude = "88.5954331862506"
        model7.airport = LanguageConstant.suggestionSevenAirport
        model7.railway = LanguageConstant.suggestionSevenRailway
        model7.city = LanguageConstant.suggestionSevenCity
        model7.about = LanguageConstant.suggestionSevenAbout
        models.append(model7)
        
        let model8 = SuggestionProvider()
        model8.id = 108
        model8.image = "https://i.postimg.cc/xC0gNHHN/gettyimages-110051027-612x612.jpg"
        model8.title = LanguageConstant.suggestionEightTitle
        model8.subTitle = LanguageConstant.suggestionEightSubTitle
        model8.latitude = "19.075039297565237"
        model8.longitude = "72.87979627430282"
        model8.airport = LanguageConstant.suggestionEightAirport
        model8.railway = LanguageConstant.suggestionEightRailway
        model8.city = LanguageConstant.suggestionEightCity
        model8.about = LanguageConstant.suggestionEightAbout
        models.append(model8)
    
        let model9 = SuggestionProvider()
        model9.id = 109
        model9.image = "https://i.postimg.cc/kG7r4BMT/Dudhsagar-Waterfalls.jpg"
        model9.title = LanguageConstant.suggestionNineTitle
        model9.subTitle = LanguageConstant.suggestionNineSubTitle
        model9.latitude = "15.314485894177619"
        model9.longitude = "74.3142967488798"
        model9.airport = LanguageConstant.suggestionNineAirport
        model9.railway = LanguageConstant.suggestionNineRailway
        model9.city = LanguageConstant.suggestionNineCity
        model9.about = LanguageConstant.suggestionNineAbout
        models.append(model9)
        
        return models
    }
}
