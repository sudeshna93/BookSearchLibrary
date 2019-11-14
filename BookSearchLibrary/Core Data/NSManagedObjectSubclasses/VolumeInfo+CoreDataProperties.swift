//
//  VolumeInfo+CoreDataProperties.swift
//  
//
//  Created by K Y on 11/13/19.
//
//

import Foundation
import CoreData


extension VolumeInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VolumeInfo> {
        return NSFetchRequest<VolumeInfo>(entityName: "VolumeInfo")
    }

    @NSManaged public var title: String?
    @NSManaged public var imageLinks: ImageLinks
    @NSManaged public var bookModel: BookModel

}
