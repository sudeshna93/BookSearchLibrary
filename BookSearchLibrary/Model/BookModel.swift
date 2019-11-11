//
//  BookModel.swift
//  BookSearchLibrary
//
//  Created by Consultant on 11/8/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import Foundation

struct BookModelResponse: Decodable {
    let books: [BookModel]
    
    enum CodingKeys: String, CodingKey {
        case books = "items"
    }
}
struct BookModel: Decodable {
    let volumeInfo: VolumeInfo
    
    enum CodingKeys: String, CodingKey {
        case volumeInfo = "volumeInfo"
    }
}

struct VolumeInfo: Decodable {
    let title: String?
    let imageLinks: ImageLinks
    
    enum codingKeys: String, CodingKey {
        case title = "title"
        case imageLinks = "imageLinks"
    }
}

struct ImageLinks: Decodable {
    let thumbnail: String?
    
    
    enum CodingKeys: String, CodingKey {
        case thumbnail = "thumbnail"
    }
}
