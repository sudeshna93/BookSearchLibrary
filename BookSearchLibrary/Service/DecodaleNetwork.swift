//
//  DecodaleNetwork.swift
//  BookSearchLibrary
//
//  Created by Consultant on 11/8/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import Foundation

class DecodableNetwork {
    
    //properties
    
    var jsonDecoder = JSONDecoder()
    var session : URLSession
    
    var currentTask: [URL:URLSessionDataTask] = [:]
    
    
    init(_ session: URLSession) {
        self.session = session
    }
    
    //MARK: networking methods
    
    func getData(_ url:URL, _ completion: @escaping (Data?)-> Void){
        
        //if i already enqueued a task, cancel an existing task
        cancelTask(url)
        
        //make a task
        let task = session.dataTask(with: url){(dat,_,_) in
         completion(dat)
        }
        
        //keep task of new task
        currentTask[url] = task
        
        //artificial delay
        
        let delay = Double.random(in: 0.5...2.0)
        let dispatchTask : ()->Void = {
            task.resume()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay,
        execute: dispatchTask)
    }
    
    func cancelTask(_ url: URL){
        if let curr = currentTask[url]{
            curr.cancel()
        }
    }
    
    func get<T: Decodable>(type: T.Type, url:URL, _ completion: @escaping (T?)->Void ){
        
        session.dataTask(with: url){ (data, resp, _) in
            guard let data = data else{ return }
            
            do{
                let result = try self.jsonDecoder.decode(type, from: data)
                completion(result)
            }
            catch{
                print(error)
                completion(nil)
            }
        }.resume()
        
    }
    
}

extension DecodableNetwork{
    
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
