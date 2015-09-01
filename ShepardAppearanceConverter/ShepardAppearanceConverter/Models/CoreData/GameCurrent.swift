//
//  GameCurrent.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/31/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation
import CoreData

extension CurrentGame: CoreDataStorable {
    public static var coreDataEntityName: String { return "GameCurrent" }
    
    public func setAdditionalColumns(coreItem: NSManagedObject) {
        coreItem.setValue(fetchShepardRow(), forKey: "shepard")
    }
    
    public func setIdentifyingPredicate(fetchRequest: NSFetchRequest) {
    }
    
    public func save() -> Bool {
        return CoreDataManager.save(self)
    }
    
    public static func save() -> Bool {
        return CurrentGame().save()
    }
    
    public static func get() -> CurrentGame? {
        let currentGame: CurrentGame? = CoreDataManager.get({ (_) in })
        return currentGame
    }
    
    internal func fetchShepardRow() -> NSManagedObject? {
        let identifyingSequence = CurrentGame.shepard
        if let row = identifyingSequence.nsManagedObject {
            return row
        } else {
            identifyingSequence.save()
            return identifyingSequence.nsManagedObject
        }
    }
}