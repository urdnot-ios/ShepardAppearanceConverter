//
//  GameShepardsSequences.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/31/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation
import CoreData

extension GameSequence: CoreDataStorable {
    public static var coreDataEntityName: String { return "GameSequences" }
    
    public func setAdditionalColumns(coreItem: NSManagedObject) {
        coreItem.setValue(uuid, forKey: "uuid")
    }
    
    public func setIdentifyingPredicate(fetchRequest: NSFetchRequest) {
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid)
    }
    
    public mutating func save() -> Bool {
        shepard.saveAnyChanges()
        let isSaved = CoreDataManager.save(self)
        return isSaved
    }
    
    public mutating func saveAnyChanges() -> Bool {
        // currently GameSequence saves on any changes, so we don't need to save game, but that may change.
        // But shepard doesn't save all the time, so save it if it has unsaved changes:
        var isSaved = shepard.saveAnyChanges()
        isSaved = isSaved && save()
        return isSaved
    }
    
    public mutating func delete() -> Bool {
        var isDeleted = true
        for shepard in allShepards {
            isDeleted = Shepard.delete(uuid: shepard.uuid) && isDeleted
        }
        return CoreDataManager.delete(self) && isDeleted
    }
    
    public static func delete(uuid uuid: String, shepardUuids: [String]) -> Bool {
        var isDeleted = true
        for shepardUuid in shepardUuids {
            isDeleted = Shepard.delete(uuid: shepardUuid) && isDeleted
        }
        return CoreDataManager.delete(matching: [(key: "uuid", value: uuid)], itemType: GameSequence.self) && isDeleted
    }
    
    public static func get(uuid uuid: String) -> GameSequence? {
        return get(matching: [(key: "uuid", value: uuid)])
    }
    
    public static func get(matching criteria: [MatchingCriteria]) -> GameSequence? {
        let game: GameSequence? = CoreDataManager.get(matching: criteria)
        return game
    }
    
    public static func lastPlayed() -> GameSequence? {
        let game: GameSequence? = CoreDataManager.get(matching: [], sortBy: [(key: "modifiedDate", ascending: false)])
        return game
    }
    
    public static func getAll() -> [GameSequence] {
        let allGames: [GameSequence] = CoreDataManager.getAll() as [GameSequence] ?? []
        return allGames
    }
}
