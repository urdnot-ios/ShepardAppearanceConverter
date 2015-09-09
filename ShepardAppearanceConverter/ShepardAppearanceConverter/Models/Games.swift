//
//  Games.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 9/3/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

public struct Games {

    private var contents: [FaultedGameSequence] = []
    
    public init() {}
    
    public init(startingGame game: GameSequence) {
        contents = [FaultedGameSequence(uuid: game.uuid, shepardUuids: game.allShepards.map { $0.uuid })]
    }
    
    public init(serializedData data: String) throws { // protocol conformance SerializedDataRetrievable
        try setData(serializedData: data)
    }
    
}

// Array type protocols

extension Games {

    public mutating func add(game: GameSequence) {
        contents.append(FaultedGameSequence(uuid: game.uuid, shepardUuids: game.allShepards.map { $0.uuid }))
    }
    
    public mutating func delete(uuid uuid: String) -> Bool {
        if let foundIndex = contents.indexOf({ $0.uuid == uuid }) {
            let game = contents.removeAtIndex(foundIndex)
            if game.uuid == App.currentGame.uuid {
                App.currentGame = lastPlayedGame
            }
            return GameSequence.delete(uuid: game.uuid, shepardUuids: game.shepardUuids)
        }
        return false
    }
    
    public func sortedUnfaultedGames() -> [GameSequence] {
        // don't db current game, use local copy, but grab all the others:
        let list = contents.map{ App.currentGame.uuid == $0.uuid ? App.currentGame : GameSequence(uuid: $0.uuid) }.filter{ $0 != nil }.map{ $0! }
        return list.sort{ $0.shepard.modifiedDate.compare($1.shepard.modifiedDate) == .OrderedDescending }
    }
    
    public var lastPlayedGame: GameSequence {
        // loads from database or creates new
        return GameSequence.lastPlayed() ?? GameSequence()
    }

}

extension Games: CollectionType {

    public typealias Index = Int
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return contents.count
    }
    
    public subscript(index: Int) -> FaultedGameSequence {
        get {
            return contents[index]
        }
        set {
            return contents[index] = newValue
        }
    }
    
}

extension Games: SequenceType {

    public typealias Generator = AnyGenerator<FaultedGameSequence>
    
    public func generate() -> Generator {
        var index = 0
        return anyGenerator {
            return index < self.contents.count ? self.contents[index++] : nil
        }
    }
    
}

extension Games: RangeReplaceableCollectionType {

    public mutating func replaceRange<C : CollectionType where C.Generator.Element == Generator.Element>(subRange: Range<Games.Index>, with newElements: C) {
        contents.replaceRange(subRange, with: newElements)
    }
    
}
    
//MARK: Saving/Retrieving Data

extension Games: SerializedDataStorable {

    public func getData() -> SerializedData {
        return SerializedData(contents.map { $0.getData() })
    }
    
}

extension Games: SerializedDataRetrievable {

    public mutating func setData(data: SerializedData) {
        if let allGames = data.array where allGames.count > 0 {
            contents = []
            for data in allGames {
                contents.append(FaultedGameSequence(data: data))
            }
        }
    }
    
    public mutating func setData(serializedData data: String) throws {
        setData(try SerializedData(serializedData: data))
    }
    
}