//
//  CurrentGame.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/9/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

public class CurrentGame {
    
    public init() {} // sometimes we need an instantiated version for SerializedDataStorable uses
    
    public required init(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws { // SerializedDataRetrievable protocol conformance
        try setData(serializedData: data, origin: origin)
    }

    public static var shepard: Shepard = {
        var shepard = Shepard(game: .Game1) // or load from NSUserDefaults or something?
        shepard.onChange.listen(CurrentGame.self) { (shepard) in
            CurrentGame.onCurrentShepardChange.fire(true)
        }
        return shepard
    }()
//    {
//        didSet {
//            if shepard != oldValue && oldValue.hasUnSavedGames {
//                SavedGames.saveShepard(oldValue)
//            }
//        }
//    }
    
    public class func changeGame(newGame: Shepard.Game) {
        let oldGame = CurrentGame.shepard.game
        var newGameSameShepard = false
        let index: Int = {
            if let foundIndex = SavedGames.shepardsSequences.indexOf({ $0.match(CurrentGame.shepard) }) {
                SavedGames.saveShepard(CurrentGame.shepard)
                newGameSameShepard = true
                return foundIndex
            } else {
                var newShepard = SavedGames.addNewShepard(newGame, shepard: Shepard(game: newGame))
                newShepard.hasUnSavedGames = true
                return SavedGames.shepardsSequences.count - 1
            }
        }()
        if let foundShepard = SavedGames.shepardsSequences[index].getGame(newGame) {
            CurrentGame.changeShepard(foundShepard)
        } else {
            var newShepard = Shepard(game: newGame)
            if newGameSameShepard {
                //ask first?
                newShepard.setData(CurrentGame.shepard.getData(), gameConversion: oldGame, origin: .DataChange)
            }
            SavedGames.saveShepard(newShepard, atIndex: index)
            CurrentGame.changeShepard(newShepard)
        }
    }
    
    public class func changeShepard(newShepard: Shepard) {
        CurrentGame.shepard.setData(newShepard.getData(), origin: .LocalStore)
        SavedGames.markShepardAsLastPlayed(newShepard)
        CurrentGame.onCurrentShepardChange.fire(true)
        CurrentGame.save()
    }
    
//MARK: Listeners
    
    // notifies of any change to current shepard (which is really any change to any shepard, since you can only change the current one)
    public static let onCurrentShepardChange = Signal<(Bool)>()
}

extension CurrentGame: SerializedDataStorable {

    public func getData(target target: SerializedDataOrigin = .LocalStore) -> SerializedData {
        return CurrentGame.getData(target: target)
    }
    
    public class func getData(target target: SerializedDataOrigin = .LocalStore) -> SerializedData {
        var list = [String: SerializedDataStorable?]()
        list["shepard_uuid"] = CurrentGame.shepard.uuid
        return SerializedData(list)
    }
    
}

extension CurrentGame: SerializedDataRetrievable {
    
    public func setData(data: SerializedData, origin: SerializedDataOrigin = .LocalStore) {
        CurrentGame.setData(data, origin: origin)
    }
    
    public class func setData(data: SerializedData, origin: SerializedDataOrigin = .LocalStore) {
        guard let shepardUuid = data["shepard_uuid"]?.string
        else {
            return
        }
        if let shepard = SavedGames.findShepard(shepardUuid) {
            CurrentGame.changeShepard(shepard)
        }
    }
    
    public func setData(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws {
        CurrentGame.setData(try SerializedData(serializedData: data), origin: origin)
    }
    
    public class func setData(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws {
        CurrentGame.setData(try SerializedData(serializedData: data), origin: origin)
    }
    
}