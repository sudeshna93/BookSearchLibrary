//
//  BookModelView.swift
//  BookSearchLibrary
//
//  Created by Consultant on 11/9/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import Foundation


protocol BookModelViewProtocol {
    var books: [BookModel] { get }
    var isSearching: Bool { get }
    func download(search: String, _ completion: @escaping ([BookModel])-> Void)
    func getPicture(_ url: URL, _ completion: @escaping (Data?)-> Void)
  //  func search(query: String) -> [BookModel]
    func cancelTask(_ oldURL: URL)
    func favourite(at index: Int) -> Bool
}

class BookModelView: BookModelViewProtocol {
    
    //MARK:Properties
    private var allBooks: [BookModel] = []
    var updateDelegate: BookUpdateDelegate?
    
    //the filtered copy
    var books: [BookModel] = []
    var isSearching: Bool = false
    let coreData = CoreDataManager()
    lazy var networker: DecodableNetwork = {
        return DecodableNetwork(URLSession(configuration: .default),
                                self.coreData.mainContext)
    }()
    lazy var pictureService: PictureService = {
        return PictureService(networker)
    }()
    
    init() { }
    
    //MARK: Methods
    func download(search: String, _ completion: @escaping ([BookModel]) -> Void) {
        /*
        if books.isEmpty == false{
            completion(books)
            return
        }
        */
        // if doing no search, clear books.
        if search.isEmpty {
            books = []
            completion(books)
            return
        }
        
        // sanitize input
        guard let searchTerm = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(books)
            return
        }
        
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(searchTerm)"
        let url = URL(string: urlString)!
        networker.get(type: BookModelResponse.self, url: url) { (result) in
            print("download finished")
           // self.allBooks = result!.books
           // self.books = self.allBooks
            
            print(self.allBooks)
           // print(result!)
            if result?.books != nil,
                let books = result?.books.array as? [BookModel] {
                self.allBooks = books
                self.books = self.allBooks
            }
            completion(self.books)
            
        }
    }
    
    func cancelTask(_ oldURL: URL) {
        networker.cancelTask(oldURL)
    }
    
    func getPicture(_ url: URL, _ completion: @escaping (Data?) -> Void) {
        pictureService.get(url, completion)
    }
    
    func favourite(at index: Int) -> Bool {
        return updateDelegate?.didFavorite(books[index]) ?? false
    }
    
}
