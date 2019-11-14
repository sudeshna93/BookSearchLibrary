//
//  CoreDataManager.swift
//  BookSearchLibrary
//
//  Created by K Y on 11/13/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import Foundation
import CoreData

private let containerName = "BookSearchLibrary"

class CoreDataManager {
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MOC: initializes with a concurrency type
    //      dedicates a single thread for them to do work on
    // main - main thread
    // private - any background thread
    
    lazy var mainContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        return moc
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.parent = self.mainContext
        return moc
    }()
    
    // MARK - Lifecycle Methods
    
    init() { }
    
    deinit {
        saveBackground()
        saveMain()
    }
    
    // MARK: - Core Data Saving support
    
    func saveMain() {
        saveHelper(mainContext)
    }
    
    func saveBackground() {
        saveHelper(backgroundContext)
    }
    
    func saveHelper(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
