//
//  BookModelView.swift
//  BookSearchLibrary
//
//  Created by Consultant on 11/9/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import Foundation

protocol BookViewModelProtocol {
    var books: [BookModel] { get }
    var isSearching: Bool { get }
    
    func bind(_ update: @escaping ()->Void)
    func bindAndFire(_ update: @escaping ()->Void)
    func unbind()
    
    func download(search: String)
    func getPicture(_ url: URL, _ completion: @escaping (Data?)-> Void)
  //  func search(query: String) -> [BookModel]
    func cancelTask(_ oldURL: URL)
}

class BookViewModel: BookViewModelProtocol {
    
//    static let shared = BookModelView()
    init(){}
    
    //MARK:Properties
    private var allBooks: [BookModel] = []
    private var update: (()->Void)?
    
    //the filtered copy
    var books: [BookModel] = [] {
        didSet {
            update?()
        }
    }
    var isSearching: Bool = false
    let networker = DecodableNetwork()
    lazy var pictureService: PictureService = {
        return PictureService(networker)
    }()
    
    func bind(_ update: @escaping ()->Void) {
        self.update = update
    }
    
    func bindAndFire(_ update: @escaping ()->Void) {
        self.update = update
        update()
    }
    
    func unbind() {
        update = nil
    }
    
    //MARK: Methods
    func download(search: String) {
        /*
        if books.isEmpty == false{
            completion(books)
            return
        }
        */
        // if doing no search, clear books.
        if search.isEmpty {
            books = []
            return
        }
        
        // sanitize input
        guard let searchTerm = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(searchTerm)"
        let url = URL(string: urlString)!
        networker.get(type: BookModelResponse.self, url: url) { (result) in
           // self.allBooks = result!.books
           // self.books = self.allBooks
            if result?.books != nil{
                self.allBooks = result!.books
                self.books = self.allBooks
            }
            
        }
    }
    
    func cancelTask(_ oldURL: URL) {
        networker.cancelTask(oldURL)
    }
    
    func getPicture(_ url: URL, _ completion: @escaping (Data?) -> Void) {
        pictureService.get(url, completion)
    }
    
    
}
