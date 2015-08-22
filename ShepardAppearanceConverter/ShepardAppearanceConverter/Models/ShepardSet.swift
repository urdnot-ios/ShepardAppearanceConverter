//
//  ShepardSet.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/12/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

public struct ShepardSet {
    private var contents: [Shepard.Game: Shepard] = [:]
    public var lastPlayedGame = Shepard.Game.Game1
    public init(game: Shepard.Game, shepard: Shepard) {
        addGame(game, shepard: shepard)
    }
    public mutating func addGame(game: Shepard.Game, shepard: Shepard) {
        lastPlayedGame = game // move to separate explicit function
        contents[game] = shepard
    }
    public func getGame(game: Shepard.Game) -> Shepard? {
        return contents[game]
    }
    public mutating func setGame(game: Shepard.Game, shepard: Shepard) {
        contents[game] = shepard
        if contents.count > 1 {
            for (otherGame, var otherGameShepard) in contents where otherGame != game {
                otherGameShepard.setCommonData(shepard.getData())
                contents[otherGame] = otherGameShepard
            }
        }
        lastPlayedGame = game // move to separate explicit function
    }
    public var first: Shepard {
        return (contents[.Game1] ?? (contents[.Game2] ?? contents[.Game3]))!
    }
    public var last: Shepard {
        return (contents[.Game3] ?? (contents[.Game2] ?? contents[.Game1]))!
    }
    public var lastPlayed: Shepard {
        return contents[lastPlayedGame] ?? last
    }
    public var sortDate: NSDate {
        return last.modifiedDate
    }
    public func find(uuid: String) -> Shepard? {
        for shepard in contents.values {
            if shepard.uuid == uuid {
                return shepard
            }
        }
        return nil
    }
    public func match(shepard: Shepard) -> Bool {
        for shepardB in contents.values {
            if shepard == shepardB {
                return true
            }
        }
        return false
    }
    public init(data: SerializableData) {
        setData(data)
    }
    public func getData() -> SerializableData {
        return SerializableData( Dictionary(contents.map { ($0.rawValue, $1.getData()) }) )
    }
    public mutating func setData(data: SerializableData) {
        contents = Dictionary( (data.dictionary ?? [:]).map { (Shepard.Game(rawValue: $0 ?? "0") ?? .Game1, Shepard(data: $1)) })
    }
}