//
//  CoreDataStack.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 25.12.2022.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    static let modelName = "WebBrowser"
    
    static let model: NSManagedObjectModel = {
        guard
            let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL) else {
            return NSManagedObjectModel()
        }
        return model
    }()
    
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: CoreDataStack.modelName,
            managedObjectModel: CoreDataStack.model
        )
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                print("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let viewContext = storeContainer.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        
        return viewContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let backgroundContext = NSManagedObjectContext(
            concurrencyType: .privateQueueConcurrencyType
        )
        backgroundContext.parent = managedObjectContext
        return backgroundContext
    }()
    
    func saveContext() {
        guard managedObjectContext.hasChanges else { return }
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Couldn't save changes to managedObjectContext. Error: \(error), \(error.userInfo)")
        }
    }
    
    func sychronizeConext() {
        guard backgroundContext.hasChanges else { return }
        do {
            try backgroundContext.save()
            saveContext()
            NotificationCenter.default.post(name: .bookmarksRepositoryHasChanged, object: nil)
        } catch let error as NSError {
            print("Couldn't synhronize contexts. Error: \(error), \(error.userInfo)")
        }
    }
}
