//
//  BookModel+Equatable.swift
//  BookSearchLibrary
//
//  Created by K Y on 11/13/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import Foundation

extension BookModel {
    static func ==(lhs: BookModel, rhs: BookModel) -> Bool {
        return lhs.volumeInfo.title == rhs.volumeInfo.title
    }
}
