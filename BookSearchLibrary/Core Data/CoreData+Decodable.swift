//
//  CoreData+Decodable.swift
//  BookSearchLibrary
//
//  Created by K Y on 11/13/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

/*
 This file contains extra utilities for making Decodable Core Data.
 
 */

import Foundation

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "CoreDataMOC")!
}
