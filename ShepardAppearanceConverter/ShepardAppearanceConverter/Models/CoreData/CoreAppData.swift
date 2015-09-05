//
//  GameCurrent.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/31/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation
import CoreData

extension App: CoreDataStorable {

    public static var coreDataEntityName: String { return "AppData" }
    
    public func setAdditionalColumns(coreItem: NSManagedObject) {}
    
    public func setIdentifyingPredicate(fetchRequest: NSFetchRequest) {}
    
    public func save() -> Bool {
        App.currentGame.save()
        let isSaved = CoreDataManager.save(self)
        return isSaved
    }
    
    public static func save() -> Bool {
        return App().save()
    }
    
    public static func get() -> App? {
        let appData: App? = CoreDataManager.get({ (_) in })
        return appData
    }
    
}