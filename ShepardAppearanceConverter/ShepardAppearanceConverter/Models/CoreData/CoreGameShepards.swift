//
//  GameShepards.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/31/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation
import CoreData

extension Shepard: CoreDataDatedStorable {

    public static var coreDataEntityName: String { return "GameShepards" }
//    var createdDate: NSDate { get }
//    var modifiedDate: NSDate { get set }
    
    public func setAdditionalColumns(coreItem: NSManagedObject) {
        coreItem.setValue(sequenceUuid, forKey: "sequenceUuid")
        coreItem.setValue(uuid, forKey: "uuid")
        coreItem.setValue(fetchSequenceRow(), forKey: "sequence")
    }
    
    public func setIdentifyingPredicate(fetchRequest: NSFetchRequest) {
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid)
    }
    
    public mutating func save() -> Bool {
        let isSaved = CoreDataManager.save(self)
        if isSaved {
            hasUnsavedChanges = false
        }
        return isSaved
    }
    
    public mutating func delete() -> Bool {
//        if self == CurrentGame.shepard {
//            // pick the most recent game instead (we always need a current shepard):
//            let newShepard = SavedGames.shepardsSequences.sort{ $0.sortDate.compare($1.sortDate) == .OrderedDescending }.first?.lastPlayed ?? Shepard()
//            CurrentGame.changeShepard(newShepard)
//        }
        let isDeleted = CoreDataManager.delete(self)
        return isDeleted
    }
    
    public static func delete(uuid uuid: String) -> Bool {
        return CoreDataManager.delete(matching: [(key: "uuid", value: uuid)], itemType: Shepard.self)
    }
    
    public static func get(uuid uuid: String) -> Shepard? {
        return get(matching: [(key: "uuid", value: uuid)])
    }
    
    public static func get(matching criteria: [MatchingCriteria]) -> Shepard? {
        let shepard: Shepard? = CoreDataManager.get(matching: criteria)
        return shepard
    }
    
    public static func getAll() -> [Shepard] {
        let shepards: [Shepard] = CoreDataManager.getAll()
        return shepards
    }
    
    public static func getCurrent() -> Shepard? {
        let shepard: Shepard? = CoreDataManager.get(matching: [(key: "isCurrent", value: true)])
        return shepard
    }
    
    internal func fetchSequenceRow() -> NSManagedObject? {
        if let identifyingSequence = GameSequence(uuid: sequenceUuid) {
            return identifyingSequence.nsManagedObject
        }
        // save game sequence new?
        return nil
    }
    
}