//
//  FaultedShepard.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 9/5/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import Foundation

public struct FaultedShepard {

    public var uuid: String = ""
    
    public var gameVersion: GameSequence.GameVersion = .Game1
    
    public init() {}
    
    public init(uuid: String, gameVersion: GameSequence.GameVersion) {
        self.uuid = uuid
        self.gameVersion = gameVersion
    }
    
}
    
//MARK: Saving/Retrieving Data

extension FaultedShepard: SerializedDataStorable {

    public func getData() -> SerializedData {
        var list = [String: SerializedDataStorable?]()
        list["uuid"] = uuid
        list["gameVersion"] = gameVersion.rawValue
        return SerializedData(list)
    }
    
}

extension FaultedShepard: SerializedDataRetrievable {

    public init(data: SerializedData) {
        setData(data)
    }
    
    public init(serializedData data: String) throws {
        try setData(serializedData: data)
    }
    
    public mutating func setData(data: SerializedData) {
        guard let uuid = data["uuid"]?.string,
              let gameVersion = GameSequence.GameVersion(rawValue: data["gameVersion"]?.string ?? "")
        else {
            return
        }
        self.uuid = uuid
        self.gameVersion = gameVersion
    }
    
    public mutating func setData(serializedData data: String) throws {
        let extractedData = try SerializedData(serializedData: data)
        setData(extractedData)
    }
    
}

//MARK: Equatable

extension FaultedShepard: Equatable {}

public func ==(lhs: FaultedShepard, rhs: FaultedShepard) -> Bool {
    return lhs.uuid == rhs.uuid
}

