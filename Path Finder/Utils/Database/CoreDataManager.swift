//
//  DatabaseHandler.swift
//  Path Finder
//
//  Created by Vishwa Fernando on 2024-04-23.
//

import Foundation
import CoreData
import UIKit

internal struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Path_Finder")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }
        
        return container
    }()
}
