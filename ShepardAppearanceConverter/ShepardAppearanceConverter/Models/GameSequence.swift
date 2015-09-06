//
//  CurrentGame.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/9/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

public struct GameSequence {

    public typealias ShepardVersionIdentifier = (uuid: String, gameVersion: GameVersion)
    
    public var allShepards = [FaultedShepard]()
    
    public var uuid = "\(NSUUID().UUIDString)"
    
    public var gameVersion: GameVersion {
        return shepard.gameVersion
    }
    
    public var shepard: Shepard

    public init() {
        shepard = Shepard(sequenceUuid: self.uuid, gameVersion: .Game1)
        allShepards.append(FaultedShepard(uuid: shepard.uuid, gameVersion: .Game1))
    }
    
    public init?(uuid: String) {
        guard let game = GameSequence.get(uuid: uuid)
        else {
            return nil
        }
        self = game
    }
    
    public mutating func changeGameVersion(newGameVersion: GameVersion) {
        if newGameVersion == gameVersion {
            return
        }
        // save prior shepard
        shepard.saveAnyChanges()
        // locate new shepard
        if let foundIndex = allShepards.indexOf({ $0.gameVersion == newGameVersion }),
           let foundShepard = Shepard.get(uuid: allShepards[foundIndex].uuid) {
            shepard = foundShepard
        } else {
            var newShepard = Shepard(sequenceUuid: uuid, gameVersion: newGameVersion)
            // share all data from other game version:
            newShepard.setData(shepard.getData(), gameConversion: shepard.gameVersion, origin: .DataChange)
            newShepard.saveAnyChanges()
            allShepards.append(FaultedShepard(uuid: newShepard.uuid, gameVersion: newGameVersion))
            if let foundIndex = App.allGames.indexOf({ $0.uuid == uuid }) {
                App.allGames[foundIndex].shepardUuids = allShepards.map { $0.uuid }
            }
            shepard = newShepard
        }
        // reset the listeners (new value = new listeners)
        App.resetShepardListener()
        // save current game and shepard (to mark most recent)
        saveAnyChanges()
    }
    
    
}

extension GameSequence: SerializedDataStorable {

    public func getData(target target: SerializedDataOrigin = .LocalStore) -> SerializedData {
        var list = [String: SerializedDataStorable?]()
        list["uuid"] = uuid
        list["last_played_shepard"] = shepard.uuid
        list["all_shepards"] = SerializedData(allShepards.map { $0.getData() })
        if target == .LocalStore {
        } else if target == .Database {
        }
        return SerializedData(list)
    }
    
}
extension GameSequence: SerializedDataRetrievable {
    
    public init(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws {
        self.init()
        setData(try SerializedData(serializedData: data), origin: origin)
    }

    public mutating func setData(data: SerializedData, origin: SerializedDataOrigin = .LocalStore) {
        uuid = data["uuid"]?.string ?? uuid
        if let lastPlayedShepard = data["last_played_shepard"]?.string,
           let shepard = Shepard.get(uuid: lastPlayedShepard) {
            self.shepard = shepard
            changeGameVersion(shepard.gameVersion)
        }
        if let allShepards = data["all_shepards"]?.array {
            self.allShepards = []
            for faultedShepardData in allShepards {
                self.allShepards.append(FaultedShepard(data: faultedShepardData))
            }
        }
    }
    
}

//MARK: Supporting data type

extension GameSequence {
    
    public enum GameVersion: String {
        case Game1 = "1", Game2 = "2", Game3 = "3"
        func list() -> [GameVersion] {
            return [.Game1, .Game2, .Game3]
        }
    }

}

extension GameSequence.GameVersion: Equatable {}

public func ==(lhs: GameSequence.GameVersion, rhs: GameSequence.GameVersion) -> Bool {
    return lhs.rawValue == rhs.rawValue
}


