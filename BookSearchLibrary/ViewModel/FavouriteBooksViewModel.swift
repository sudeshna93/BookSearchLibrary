//
//  FavouriteBooksViewModel.swift
//  BookSearchLibrary
//
//  Created by K Y on 11/13/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import Foundation


protocol FavouritedBooksViewModelProtocol {
    /// favorite books
    var favourites: [BookModel] { get }
}

class FavouritedBooksViewModel: FavouritedBooksViewModelProtocol {
    
    var favourites: [BookModel] = []
    
    init(_ books: [BookModel]) {
        favourites = books
    }
    
}

extension FavouritedBooksViewModel: BookUpdateDelegate {
    func didFavorite(_ book: BookModel) -> Bool {
        if !favourites.contains(book) {
            favourites.append(book)
            return true
        }
        return false
    }
    
}
