//
//  CoreDataManager.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/30/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit
import CoreData

public enum CoreDataManagerError : ErrorType {
//    case DataNotFound
}

public typealias SetAdditionColumnsClosure = ((NSManagedObject)->Void)
public typealias SetSearchPredicateClosure = ((NSFetchRequest)->Void)
public typealias MatchingCriteria = (key: String, value: CVarArgType)
public typealias SortingCriteria = (key: String, ascending: Bool)

public struct CoreDataManager {

    public static var context: NSManagedObjectContext?
    
    internal struct Keys {
        static let serializedData = "serializedData"
        static let createdDate = "createdDate"
        static let modifiedDate = "modifiedDate"
    }

    /// save a single row
    public static func save<T: CoreDataStorable>(item: T) -> Bool {
        guard let context = self.context else {
            print("Error: could not initalize core data context")
            return false
        }
        guard let entity = NSEntityDescription.entityForName(T.coreDataEntityName, inManagedObjectContext: context) else {
            print("Error: could not find core data entity \(T.coreDataEntityName)")
            return false
        }
        
        let coreItem = fetchRow(item) ?? NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        coreItem.setValue(item.getData().serializedData, forKey: Keys.serializedData)
        if let datedItem = item as? CoreDataDatedStorable {
            coreItem.setValue(datedItem.createdDate, forKey: Keys.createdDate)
            coreItem.setValue(datedItem.modifiedDate, forKey: Keys.modifiedDate)
        }
        
        item.setAdditionalColumns(coreItem)
        
        do {
            try context.save()
            return true
        } catch let saveError as NSError {
            print("save failed for \(T.coreDataEntityName): \(saveError.localizedDescription)")
        }
        
        return false
    }
    
    
    
    /// delete single row with item passed
    public static func delete<T: CoreDataStorable>(item: T) -> Bool {
        guard let context = self.context else {
            print("Error: could not initalize core data context")
            return false
        }
        
        do {
            if let coreItem = item.nsManagedObject {
                context.deleteObject(coreItem)
                try context.save()
                return true
            }
        } catch let deleteError as NSError{
            print("delete failed for \(T.coreDataEntityName): \(deleteError.localizedDescription)")
        }
        
        return false
    }
    
    /// retrieve single row with criteria closure
    public static func delete<T: CoreDataStorable>(setSearchPredicates: SetSearchPredicateClosure, sortBy: [SortingCriteria] = [], itemType: T.Type) -> Bool {
        guard let context = self.context else {
            print("Error: could not initalize core data context")
            return false
        }
        
        do {
            if let coreItem = fetchRow(setSearchPredicates, sortBy: sortBy, itemType: itemType) {
                context.deleteObject(coreItem)
                try context.save()
                return true
            }
        } catch let deleteError as NSError {
            print("delete failed for \(T.coreDataEntityName): \(deleteError.localizedDescription)")
        }
        return false
    }
    
    /// retrieve single row with criteria list
    public static func delete<T: CoreDataStorable>(matching matching: [MatchingCriteria], sortBy: [SortingCriteria] = [], itemType: T.Type) -> Bool {
        let predicates: [NSPredicate] = matching.map { NSPredicate(format: "\($0.key) = %@", $0.value) }
        let setSearchPredicates: SetSearchPredicateClosure = { (fetchRequest) in
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        return self.delete(setSearchPredicates, sortBy: sortBy, itemType: itemType)
    }
    
    
    /// retrieve multiple rows
    public static func getAll<T: CoreDataStorable>() -> [T] {
        return getAll({ (_) in })
    }
    
    /// retrieve multiple rows with criteria closure
    public static func getAll<T: CoreDataStorable>(setSearchPredicates: (SetSearchPredicateClosure), sortBy: [SortingCriteria] = []) -> [T] {
        guard let context = self.context else {
            print("Error: could not initalize core data context")
            return []
        }
        
        let fetchRequest = NSFetchRequest(entityName: T.coreDataEntityName)
        setSearchPredicates(fetchRequest)
        fetchRequest.sortDescriptors = sortBy.map { NSSortDescriptor(key: $0.key, ascending: $0.ascending) }
        
        do {
            let coreItems = (try context.executeFetchRequest(fetchRequest) as? [NSManagedObject]) ?? [NSManagedObject]()
            let results: [T] = try coreItems.map { (coreItem) in
                let serializedData = (coreItem.valueForKey(Keys.serializedData) as? String) ?? ""
                return try T(serializedData: serializedData)
            }
            return results
        } catch let fetchError as NSError {
            print("getAll failed for \(T.coreDataEntityName): \(fetchError.localizedDescription)")
        }
        
        return []
    }
    
    /// retrieve multiple rows with criteria list
    public static func getAll<T: CoreDataStorable>(matching matching: [MatchingCriteria], sortBy: [SortingCriteria] = []) -> [T] {
        let predicates: [NSPredicate] = matching.map { NSPredicate(format: "\($0.key) = %@", $0.value) }
        let setSearchPredicates: SetSearchPredicateClosure = { (fetchRequest) in
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        return self.getAll(setSearchPredicates, sortBy: sortBy)
    }



    
    /// retrieve single row with criteria closure
    public static func get<T: CoreDataStorable>(setSearchPredicates: (SetSearchPredicateClosure), sortBy: [SortingCriteria] = []) -> T? {
        do {
            if let coreItem = fetchRow(setSearchPredicates, sortBy: sortBy, itemType: T.self) {
                let serializedData = (coreItem.valueForKey(Keys.serializedData) as? String) ?? ""
                return try T(serializedData: serializedData)
            }
        } catch let fetchError as NSError {
            print("get failed for \(T.coreDataEntityName): \(fetchError.localizedDescription)")
        }
        return nil
    }
    
    /// retrieve single row with criteria list
    public static func get<T: CoreDataStorable>(matching matching: [MatchingCriteria], sortBy: [SortingCriteria] = []) -> T? {
        let predicates: [NSPredicate] = matching.map { NSPredicate(format: "\($0.key) = %@", $0.value) }
        let setSearchPredicates: SetSearchPredicateClosure = { (fetchRequest) in
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        return self.get(setSearchPredicates, sortBy: sortBy)
    }
    
    
    /// retrieve single row introspective core data
    public static func fetchRow<T: CoreDataStorable>(item: T) -> NSManagedObject? {
        guard let context = self.context else {
            print("Error: could not initalize core data context")
            return nil
        }
        
        let fetchRequest = NSFetchRequest(entityName: T.coreDataEntityName)
        fetchRequest.fetchLimit = 1
        item.setIdentifyingPredicate(fetchRequest)
        
        do {
            let coreItems = (try context.executeFetchRequest(fetchRequest) as? [NSManagedObject]) ?? [NSManagedObject]()
            return coreItems.first
        } catch let fetchError as NSError {
            print("fetchRow failed for \(T.coreDataEntityName): \(fetchError.localizedDescription)")
        }
        return nil
    }
    
    /// retrieve single row introspective core data with criteria closure
    public static func fetchRow<T: CoreDataStorable>(setSearchPredicates: SetSearchPredicateClosure, sortBy: [SortingCriteria] = [], itemType: T.Type) -> NSManagedObject? {
        guard let context = self.context else {
            print("Error: could not initalize core data context")
            return nil
        }
        
        let fetchRequest = NSFetchRequest(entityName: T.coreDataEntityName)
        fetchRequest.fetchLimit = 1
        setSearchPredicates(fetchRequest)
        fetchRequest.sortDescriptors = sortBy.map { NSSortDescriptor(key: $0.key, ascending: $0.ascending) }
        
        do {
            let coreItems = (try context.executeFetchRequest(fetchRequest) as? [NSManagedObject]) ?? [NSManagedObject]()
            return coreItems.first
        } catch let fetchError as NSError {
            print("fetch failed for \(T.coreDataEntityName): \(fetchError.localizedDescription)")
        }
        
        return nil
    }
    
    /// retrieve single row introspective core data with criteria list
    public static func fetchRow<T: CoreDataStorable>(matching matching: [MatchingCriteria], sortBy: [SortingCriteria] = [], itemType: T.Type) -> NSManagedObject? {
        let predicates: [NSPredicate] = matching.map { NSPredicate(format: "\($0.key) = %@", $0.value) }
        let setSearchPredicates: SetSearchPredicateClosure = { (fetchRequest) in
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        return self.fetchRow(setSearchPredicates, sortBy: sortBy, itemType: itemType)
    }
    
    
    /// remove all rows
    public static func truncateTable<T: CoreDataStorable>(itemType: T.Type) -> Bool {
        return truncateTable(T.coreDataEntityName)
    }
    
    public static func truncateTable(entityName: String) -> Bool {
        guard let context = self.context else {
            print("Error: could not initalize core data context")
            return false
        }
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.persistentStoreCoordinator?.executeRequest(deleteRequest, withContext: context)
        } catch let deleteError as NSError {
            print("delete failed for \(entityName): \(deleteError.localizedDescription)")
        }
        
        return false
    }
    
}