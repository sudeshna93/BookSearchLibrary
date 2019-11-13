//
//  DecodableNetwork+CoreData.swift
//  BookSearchLibrary
//
//  Created by K Y on 11/13/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import CoreData

extension DecodableNetwork {
    convenience init(_ session: URLSession, _ context: NSManagedObjectContext) {
        let decoder = JSONDecoder()
        decoder.userInfo[.context] = context
        self.init(session, decoder)
    }
}
