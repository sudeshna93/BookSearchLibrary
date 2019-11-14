//
//  VolumeInfo+CoreDataClass.swift
//  
//
//  Created by K Y on 11/13/19.
//
//

import Foundation
import CoreData

@objc(VolumeInfo)
public class VolumeInfo: NSManagedObject, Decodable  {
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case imageLinks = "imageLinks"
    }
    
    public override init(entity: NSEntityDescription,
                         insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public required init(from decoder: Decoder) throws {
        // this is called when we create the data from the network
        // context
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("Context not found")
        }
        // entity desc
        let entity = NSEntityDescription.entity(forEntityName: "VolumeInfo", in: context)!
        super.init(entity: entity, insertInto: context)
        
        // do the rest of Decodable's implicit implementation
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self,
                                          forKey: .title)
        imageLinks = try container.decode(ImageLinks.self,
                                     forKey: .imageLinks)
    }

}
