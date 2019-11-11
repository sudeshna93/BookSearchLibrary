//
//  BookModelView.swift
//  BookSearchLibrary
//
//  Created by Consultant on 11/9/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import Foundation

protocol  BookModelViewProtocol {
    var books: [BookModel] { get }
    var isSearching: Bool { get }
    func download(search: String, _ completion: @escaping ([BookModel])-> Void)
    func getPicture(_ url: URL, _ completion: @escaping (Data?)-> Void)
  //  func search(query: String) -> [BookModel]
    func cancelTask(_ oldURL: URL)
}

class BookModelView: BookModelViewProtocol {
    
//    static let shared = BookModelView()
    init(){}
    //MARK:Properties
    private var allBooks: [BookModel] = []
    
    //the filtered copy
    var books: [BookModel] = []
    var isSearching: Bool = false
    let networker = DecodableNetwork()
    lazy var pictureService: PictureService = {
        return PictureService(networker)
    }()
    
    //MARK: Methods
    func download(search: String, _ completion: @escaping ([BookModel]) -> Void) {
        if books.isEmpty == false{
            completion(books)
            return
        }
        
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(search)")!
        networker.get(type: BookModelResponse.self, url: url) { (result) in
            print("download finished")
           // self.allBooks = result!.books
           // self.books = self.allBooks
            
            print(self.allBooks)
           // print(result!)
            if result?.books != nil{
                self.allBooks = result!.books
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
    
    
}
