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

    public func getData() -> SerializedData {
        var list = [String: SerializedDataStorable?]()
        list["uuid"] = uuid
        list["shepardUuids"] = SerializedData(shepardUuids.map { $0 as SerializedDataStorable? })
        return SerializedData(list)
    }
    
}

extension FaultedGameSequence: SerializedDataRetrievable {

    public init(data: SerializedData) {
        setData(data)
    }
    
    public init(serializedData data: String) throws {
        try setData(serializedData: data)
    }
    
    public mutating func setData(data: SerializedData) {
        guard let uuid = data["uuid"]?.string,
              let shepardUuids = data["shepardUuids"]?.array?.filter({ $0.string != nil }).map({ $0.string! })
        else {
            return
        }
        self.uuid = uuid
        self.shepardUuids = shepardUuids
    }
    
    public mutating func setData(serializedData data: String) throws {
        let extractedData = try SerializedData(serializedData: data)
        setData(extractedData)
    }
    
}

//MARK: Equatable

extension FaultedGameSequence: Equatable {}

public func ==(lhs: FaultedGameSequence, rhs: FaultedGameSequence) -> Bool {
    return lhs.uuid == rhs.uuid
}