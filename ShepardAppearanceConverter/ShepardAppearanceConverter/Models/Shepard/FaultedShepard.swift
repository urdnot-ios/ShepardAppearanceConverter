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

    public func getData(target target: SerializedDataOrigin = .LocalStore) -> SerializedData {
        var list = [String: SerializedDataStorable?]()
        list["uuid"] = uuid
        list["game_version"] = gameVersion.rawValue
        return SerializedData(list)
    }
    
}

extension FaultedShepard: SerializedDataRetrievable {

    public init(data: SerializedData, origin: SerializedDataOrigin = .LocalStore) {
        setData(data, origin: origin)
    }
    
    public init(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws {
        try setData(serializedData: data, origin: origin)
    }
    
    public mutating func setData(data: SerializedData, origin: SerializedDataOrigin = .LocalStore) {
        guard let uuid = data["uuid"]?.string,
              let gameVersion = GameSequence.GameVersion(rawValue: data["game_version"]?.string ?? "")
        else {
            return
        }
        self.uuid = uuid
        self.gameVersion = gameVersion
    }
    
    public mutating func setData(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws {
        let extractedData = try SerializedData(serializedData: data, origin: origin)
        setData(extractedData, origin: origin)
    }
    
}

//MARK: Equatable

extension FaultedShepard: Equatable {}

public func ==(lhs: FaultedShepard, rhs: FaultedShepard) -> Bool {
    return lhs.uuid == rhs.uuid
}

