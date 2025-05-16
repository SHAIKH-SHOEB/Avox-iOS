//
//  AddEventProvider.swift
//  Avox
//
//  Created by Nimap on 12/01/25.
//

import UIKit

class AddEventProvider: NSObject {
    
    var id        : Int?
    var title     : String?
    var value     : Any?
    var isSelect  : Bool = false
    
    
    static func getColorTypeTitleProvider() -> [AddEventProvider] {
        var models = [AddEventProvider]()
        
        let model1 = AddEventProvider()
        model1.id = 1
        model1.title = "Red"
        model1.value = UIColor.systemRed
        models.append(model1)
        
        let model2 = AddEventProvider()
        model2.id = 2
        model2.title = "Blue"
        model2.value = UIColor.systemBlue
        models.append(model2)
        
        let model3 = AddEventProvider()
        model3.id = 3
        model3.title = "Green"
        model3.value = UIColor.systemGreen
        models.append(model3)
        
        let model4 = AddEventProvider()
        model4.id = 4
        model4.title = "Yello"
        model4.value = UIColor.systemYellow
        models.append(model4)
        
        // Sorting the models array by title
        models.sort { $0.title! < $1.title! }
        
        return models
    }
    
    static func getEventTypeTitleProvider() -> [AddEventProvider] {
        var models = [AddEventProvider]()
        
        let model1 = AddEventProvider()
        model1.id = 1
        model1.title = "Meeting"
        model1.value = UIImage(systemName: "widget.small")
        models.append(model1)
        
        let model2 = AddEventProvider()
        model2.id = 2
        model2.title = "Working"
        model2.value = UIImage(systemName: "person.text.rectangle.fill")
        models.append(model2)
        
        let model3 = AddEventProvider()
        model3.id = 3
        model3.title = "Birthday"
        model3.value = UIImage(systemName: "birthday.cake")
        models.append(model3)
        
        let model4 = AddEventProvider()
        model4.id = 4
        model4.title = "Other"
        model4.value = UIImage(systemName: "swirl.circle.righthalf.filled")
        models.append(model4)
        
        // Sorting the models array by title
        models.sort { $0.title! < $1.title! }
        
        return models
    }
    
    static func getReminderTitleProvider() -> [AddEventProvider] {
        var models = [AddEventProvider]()
        
        let model1 = AddEventProvider()
        model1.id = 1
        model1.title = "Yes"
        model1.value = UIImage(systemName: "checkmark.square")
        models.append(model1)
        
        let model2 = AddEventProvider()
        model2.id = 2
        model2.title = "No"
        model2.value = UIImage(systemName: "xmark.square")
        models.append(model2)
        
        return models
    }
}
