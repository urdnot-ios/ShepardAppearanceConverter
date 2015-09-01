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
    
    public func save() -> Bool {
        return CoreDataManager.save(self)
    }
    
    public func delete() -> Bool {
        if self == CurrentGame.shepard {
            // pick the most recent game instead (we always need a current shepard):
            let newShepard = SavedGames.shepardsSequences.sort{ $0.sortDate.compare($1.sortDate) == .OrderedDescending }.first?.lastPlayed ?? Shepard()
            CurrentGame.changeShepard(newShepard)
        }
        return CoreDataManager.delete(self)
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
        let identifyingSequence = ShepardsSequence(data: SerializedData(["uuid": sequenceUuid]))
        if let row = identifyingSequence.nsManagedObject {
            return row
        }
        let newSequence = ShepardsSequence(game: game, shepard: self)
        return newSequence.nsManagedObject
    }
}