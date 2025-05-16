//
//  ImageData+CoreDataProperties.swift
//  Avox
//
//  Created by Nimap on 02/02/24.
//
//

import Foundation
import CoreData


extension ImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageData> {
        return NSFetchRequest<ImageData>(entityName: "ImageData")
    }

    @NSManaged public var imageUrl: String?
    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?

}

extension ImageData : Identifiable {

}
