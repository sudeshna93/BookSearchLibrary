//
//  ImageLinks+CoreDataProperties.swift
//  
//
//  Created by K Y on 11/13/19.
//
//

import Foundation
import CoreData


extension ImageLinks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageLinks> {
        return NSFetchRequest<ImageLinks>(entityName: "ImageLinks")
    }

    @NSManaged public var thumbnail: String?
    @NSManaged public var volumeInfo: VolumeInfo

}
