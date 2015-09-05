//
//  FaultedGameSequence.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 9/3/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

/// Defines an abbreviates GameSequence so we don't have to download giant data for all games all the time
public struct FaultedGameSequence {

    public var uuid: String = ""
    
    public var shepardUuids: [String] = []
    
    public init() {}
    
    public init(uuid: String, shepardUuids: [String]) {
        self.uuid = uuid
        self.shepardUuids = shepardUuids
    }
    
}
    
//MARK: Saving/Retrieving Data

extension FaultedGameSequence: SerializedDataStorable {

    public func getData(target target: SerializedDataOrigin = .LocalStore) -> SerializedData {
        var list = [String: SerializedDataStorable?]()
        list["uuid"] = uuid
        list["shepard_uuids"] = SerializedData(shepardUuids.map { $0 as SerializedDataStorable? })
        return SerializedData(list)
    }
    
}

//MARK: Equatable

extension FaultedGameSequence: SerializedDataRetrievable {

    public init(data: SerializedData, origin: SerializedDataOrigin = .LocalStore) {
        setData(data, origin: origin)
    }
    
    public init(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws {
        try setData(serializedData: data, origin: origin)
    }
    
    public mutating func setData(data: SerializedData, origin: SerializedDataOrigin = .LocalStore) {
        guard let uuid = data["uuid"]?.string,
              let shepardUuids = data["shepard_uuids"]?.array?.filter({ $0.string != nil }).map({ $0.string! })
        else {
            return
        }
        self.uuid = uuid
        self.shepardUuids = shepardUuids
    }
    
    public mutating func setData(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws {
        let extractedData = try SerializedData(serializedData: data, origin: origin)
        setData(extractedData, origin: origin)
    }
    
}

extension FaultedGameSequence: Equatable {}

public func ==(lhs: FaultedGameSequence, rhs: FaultedGameSequence) -> Bool {
    return lhs.uuid == rhs.uuid
}