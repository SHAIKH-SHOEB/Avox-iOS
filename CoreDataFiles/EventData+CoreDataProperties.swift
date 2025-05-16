//
//  EventData+CoreDataProperties.swift
//  Avox
//
//  Created by Shoeb on 20/04/25.
//
//

import Foundation
import CoreData


extension EventData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventData> {
        return NSFetchRequest<EventData>(entityName: "EventData")
    }

    @NSManaged public var title: String?
    @NSManaged public var startTime: String?
    @NSManaged public var endTime: String?
    @NSManaged public var date: String?
    @NSManaged public var reminder: String?
    @NSManaged public var location: String?
    @NSManaged public var type: String?
    @NSManaged public var color: String?
    @NSManaged public var contact: String?
    @NSManaged public var note: String?
    @NSManaged public var id: String?

}

extension EventData : Identifiable {

}
