//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Dmitriy Panferov on 19/05/23.
//

import UIKit
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    private init () {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data support
    func saveContext () {
        let context = StorageManager.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // Save
    func save(_ taskName: String) -> Task {
        let task = Task(context: persistentContainer.viewContext)
        task.title = taskName
        
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        return task
    }
    // Retrieve
    func fetchData() -> [Task] {
        var taskList: [Task] = []
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return taskList
    }
    // Update
    func update(_ taskName: String, task: Task) {
        do {
            task.setValue(taskName, forKey: "title")
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


