//
//  ShepardsSequence.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/12/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

public struct ShepardsSequence {
    public private(set) var uuid = "\(NSUUID().UUIDString)"
    
    internal var shepards: [Shepard.Game: Shepard] = [:]
    
    public var lastPlayedGame = Shepard.Game.Game1
    
    public init(data: SerializedData, origin: SerializedDataOrigin = .LocalStore) { // protocol conformance SerializedDataRetrievable
        setData(data, origin: origin)
    }
    
    public init(game: Shepard.Game, shepard: Shepard) {
        shepards[game] = shepard
        uuid = shepard.sequenceUuid
        save()
    }
    
    public func getGame(game: Shepard.Game) -> Shepard? {
        return shepards[game]
    }
    
    public mutating func setGame(game: Shepard.Game, shepard: Shepard) {
        let isNew = (shepards[game] == nil)
        shepards[game] = shepard
        if isNew {
            shepards[game]?.sequenceUuid = uuid
            print("Error - saving new game in setGame")
        }
        if shepards.count > 1 {
            for (otherGame, var otherGameShepard) in shepards where otherGame != game {
                otherGameShepard.setCommonData(shepard.getData())
                shepards[otherGame] = otherGameShepard
            }
        }
//        lastPlayedGame = game // move to separate explicit function
//        save()
    }
    
    public var first: Shepard {
        return (shepards[.Game1] ?? (shepards[.Game2] ?? shepards[.Game3]))!
    }
    
    public var last: Shepard {
        return (shepards[.Game3] ?? (shepards[.Game2] ?? shepards[.Game1]))!
    }
    
    public var lastPlayed: Shepard {
        return shepards[lastPlayedGame] ?? last
    }
    
    public var sortDate: NSDate {
        return last.modifiedDate
    }
    
    public func find(uuid: String) -> Shepard? {
        return shepards.values.filter{ $0.uuid == uuid }.first
    }
    
    public func match(shepard: Shepard) -> Bool {
        return !shepards.values.filter{ $0 == shepard }.isEmpty
    }
    
}

extension ShepardsSequence: SerializedDataStorable {

    public func getData(target target: SerializedDataOrigin = .LocalStore) -> SerializedData {
        var list = [String: SerializedDataStorable?]()
        list["uuid"] = uuid
        list["last_played_game"] = lastPlayedGame.rawValue
        if target == .LocalStore {
            var shepardsList = [SerializedData]()
            for shepard in shepards.values {
                shepardsList.append(shepard.getData())
            }
            list["shepards"] = SerializedData(shepardsList)
        } else if target == .Database {
            // shepards saved by CoreData now
        }
        return SerializedData(list)
    }
    
}

extension ShepardsSequence: SerializedDataRetrievable {
    
    public init(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws {
        setData(try SerializedData(serializedData: data), origin: origin)
    }

    public mutating func setData(data: SerializedData, origin: SerializedDataOrigin = .LocalStore) {
        uuid = data["uuid"]?.string ?? uuid
        if origin == .LocalStore {
            shepards = [:]
            let shepardsData = data["shepards"]?.array ?? []
            for shepard in shepardsData {
                shepards[Shepard.Game(rawValue: shepard["game"]?.string ?? "0") ?? .Game1] = Shepard(data: shepard, origin: origin)
            }
        } else if origin == .Database {
            // shepards saved by CoreData now
        }
        lastPlayedGame = Shepard.Game(rawValue: data["last_played_game"]?.string ?? "0") ?? .Game1
    }
    
}





