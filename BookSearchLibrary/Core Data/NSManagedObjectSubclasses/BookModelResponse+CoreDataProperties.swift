//
//  BookModelResponse+CoreDataProperties.swift
//  
//
//  Created by K Y on 11/13/19.
//
//

import Foundation
import CoreData


extension BookModelResponse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookModelResponse> {
        return NSFetchRequest<BookModelResponse>(entityName: "BookModelResponse")
    }

    @NSManaged public var books: NSOrderedSet

}

// MARK: Generated accessors for books
extension BookModelResponse {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: BookModel)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: BookModel)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

}
