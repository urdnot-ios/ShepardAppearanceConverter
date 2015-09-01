//
//  GameShepardsSequences.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/31/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation
import CoreData

extension ShepardsSequence: CoreDataStorable {
    public static var coreDataEntityName: String { return "GameShepardsSequences" }
    
    public func setAdditionalColumns(coreItem: NSManagedObject) {
        coreItem.setValue(uuid, forKey: "uuid")
    }
    
    public func setIdentifyingPredicate(fetchRequest: NSFetchRequest) {
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid)
    }
    
    public func save() -> Bool {
        return CoreDataManager.save(self)
    }
    
    public func delete() -> Bool {
        var deleted = true
        let deleteShepards = shepards.values
        for shepard in deleteShepards {
            deleted = shepard.delete() && deleted
        }
        return CoreDataManager.delete(self) && deleted
    }
    
    public static func getAll() -> [ShepardsSequence] {
        let shepardsSequences: [ShepardsSequence] = CoreDataManager.getAll() as [ShepardsSequence] ?? []
        // given that these are faulted data anyway, I don't think we lose anything by requerying relationship
        let unfaultedSequences: [ShepardsSequence] = shepardsSequences.map { (var sequence) in sequence.retrieveShepards(); return sequence }
        return unfaultedSequences
    }
    
//    public static func getCurrent() -> ShepardsSequence? {
//        var shepardsSequence: ShepardsSequence? = CoreDataManager.get(matching: [(key: "ANY shepards.isCurrent = %@", value: true)])
//        shepardsSequence?.retrieveShepards()
//        return shepardsSequence
//    }
    
    public mutating func retrieveShepards() {
        let shepards: [Shepard] = CoreDataManager.getAll(matching: [(key: "sequenceUuid", value: uuid)])
        self.shepards = Dictionary( shepards.map { ($0.game, $0) } )
    }
}
