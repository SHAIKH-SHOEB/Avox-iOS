//
//  NotificationData+CoreDataProperties.swift
//  Avox
//
//  Created by Nimap on 03/02/24.
//
//

import Foundation
import CoreData


extension NotificationData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotificationData> {
        return NSFetchRequest<NotificationData>(entityName: "NotificationData")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var date: Date?

}

extension NotificationData : Identifiable {

}
