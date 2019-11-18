//
//  MockNetworkService.swift
//  BookSearchLibrary
//
//  Created by K Y on 11/18/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import Foundation
import CoreData

protocol NetworkServiceProtocol {
    func getData(_ url:URL, _ completion: @escaping (Data?)-> Void)
    func cancelTask(_ url: URL)
    func get<T: Decodable>(type: T.Type, url:URL, _ completion: @escaping (T?)->Void)
}

class MockNetworkService: NetworkServiceProtocol {
    
    //properties
    let jsonDecoder: JSONDecoder
    
    init(_ session: URLSession, _ decoder: JSONDecoder) {
        self.jsonDecoder = decoder
    }
    
    init(_ session: URLSession) {
        self.jsonDecoder = JSONDecoder()
    }
    
    //MARK: networking methods
    
    func getData(_ url:URL, _ completion: @escaping (Data?)-> Void){
        
        //if i already enqueued a task, cancel an existing task
        cancelTask(url)
        
        // load data from a file
        
        // call completion on data
    }
    
    func cancelTask(_ url: URL){
        // unimplemented
    }
    
    func get<T: Decodable>(type: T.Type, url:URL, _ completion: @escaping (T?)->Void ){
        
        // load some data from a file
        let path = Bundle.main.path(forResource: "sherlock_holmes", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            // parse the file data
            let result = try self.jsonDecoder.decode(type, from: data)
            // call completion on it
            completion(result)
        }
        catch{
            print(error)
            completion(nil)
        }
    }
    
}

extension MockNetworkService {
    
    convenience init(){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        self.init(session)
        
    }
    
    convenience init(_ config: URLSessionConfiguration) {
        let session = URLSession(configuration: config)
        self.init(session)
    }
}
extension MockNetworkService {
    
    convenience init(_ session: URLSession, _ context: NSManagedObjectContext) {
        let decoder = JSONDecoder()
        decoder.userInfo[.context] = context
        self.init(session, decoder)
    }
}
