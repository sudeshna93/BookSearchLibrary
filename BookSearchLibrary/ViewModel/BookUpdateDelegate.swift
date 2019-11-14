//
//  BookUpdateDelegate.swift
//  BookSearchLibrary
//
//  Created by K Y on 11/13/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import Foundation

protocol BookUpdateDelegate {
    /// returns Bool if adding to favourite was success, or not.
    func didFavorite(_ book: BookModel) -> Bool
}
