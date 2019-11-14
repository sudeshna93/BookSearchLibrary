//
//  BookModel+CoreDataProperties.swift
//  
//
//  Created by K Y on 11/13/19.
//
//

import Foundation
import CoreData


extension BookModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookModel> {
        return NSFetchRequest<BookModel>(entityName: "BookModel")
    }

    @NSManaged public var response: BookModelResponse
    @NSManaged public var volumeInfo: VolumeInfo

}
