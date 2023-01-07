//
//  CoreDataManager.swift
//  Nano2-Nimbl
//
//  Created by Anselmus Pavel Adriska on 04/01/23.
//

import Foundation
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "NimblModel")
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Error loading Core Data. \(error.localizedDescription)")
            } else {
                print("Successfully loading Core Data")
            }
        }
    }
    
    public func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving. \(error.localizedDescription)")
        }
    }
    
    public func delete(object: NSManagedObject) {
        container.viewContext.delete(object)
    }
}
