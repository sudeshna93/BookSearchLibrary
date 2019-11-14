//
//  BookModelResponse+CoreDataClass.swift
//  
//
//  Created by K Y on 11/13/19.
//
//

import Foundation
import CoreData

@objc(BookModelResponse)
public class BookModelResponse: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case books = "items"
    }
    
    // this is called when we load in data from disk
    public override init(entity: NSEntityDescription,
                         insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    // this is called when we create the data from the network
    public required init(from decoder: Decoder) throws {
        // context
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("Context not found")
        }
        // entity desc
        let entity = NSEntityDescription.entity(forEntityName: "BookModelResponse", in: context)!
        super.init(entity: entity, insertInto: context)
        
        // do the rest of Decodable's implicit implementation
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let booksArr = try container.decode([BookModel].self, forKey: .books)
        books = NSOrderedSet(array: booksArr)
    }

}
