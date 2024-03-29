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
    func favourite(at index: Int) -> Bool
}

class BookViewModel: BookViewModelProtocol {
    
    //MARK:Properties
    private var allBooks: [BookModel] = []
    var updateDelegate: BookUpdateDelegate?
    
    //the filtered copy
    var books: [BookModel] = [] {
        didSet {
            update?()
        }
    }
    var update: (()->Void)?
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
            if result?.books != nil,
                let books = result?.books.array as? [BookModel] {
                self.allBooks = books
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
    
    func favourite(at index: Int) -> Bool {
        return updateDelegate?.didFavorite(books[index]) ?? false
    }
    
}
