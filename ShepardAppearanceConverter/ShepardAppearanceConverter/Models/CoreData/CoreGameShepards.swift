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
    }
    
    public func setIdentifyingPredicate(fetchRequest: NSFetchRequest) {
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid)
    }
    
    public mutating func save() -> Bool {
        if hasSequenceChanges {
            saveCommonDataToAllShepardsInSequence()
        }
        let isSaved = CoreDataManager.save(self)
        if isSaved {
            hasUnsavedChanges = false
        }
        return isSaved
    }
    
    public mutating func saveAnyChanges() -> Bool {
        if hasUnsavedChanges {
            return save()
        }
        return true
    }
    
    public mutating func saveCommonDataToAllShepardsInSequence() {
        let shepards = Shepard.getAll(matching: [(key: "sequenceUuid", value: sequenceUuid)])
        let commonData = getData()
        var isSaved = true
        for var sequenceShepard in shepards {
            if sequenceShepard.uuid != uuid {
                sequenceShepard.setCommonData(commonData)
                sequenceShepard.hasSequenceChanges = false // don't recurse forever
                isSaved = isSaved && sequenceShepard.saveAnyChanges()
            }
        }
        hasSequenceChanges = !isSaved
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
    
    public static func getAll(matching criteria: [MatchingCriteria]) -> [Shepard] {
        let shepards: [Shepard] = CoreDataManager.getAll(matching: criteria)
        return shepards
    }
    
    public static func getCurrent() -> Shepard? {
        let shepard: Shepard? = CoreDataManager.get(matching: [(key: "isCurrent", value: true)])
        return shepard
    }
    
}