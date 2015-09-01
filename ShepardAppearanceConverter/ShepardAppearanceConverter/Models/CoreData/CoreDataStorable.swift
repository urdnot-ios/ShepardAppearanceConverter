//
//  CoreDataStorable.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/30/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation
import CoreData

public protocol CoreDataStorable: SerializedDataStorable, SerializedDataRetrievable {
    static var coreDataEntityName: String { get }
//    var coreDataRowIdentifer: (key: String, value: String) { get }
    
    var nsManagedObject: NSManagedObject? { get }
    
    func setIdentifyingPredicate(fetchRequest: NSFetchRequest)
    func setAdditionalColumns(coreItem: NSManagedObject)
}

extension CoreDataStorable {
    public var nsManagedObject: NSManagedObject? { return CoreDataManager.fetchRow(self) }
}

public protocol CoreDataDatedStorable: CoreDataStorable {
    var createdDate: NSDate { get }
    var modifiedDate: NSDate { get set }
}
