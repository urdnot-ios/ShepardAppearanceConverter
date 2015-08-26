//
//  CurrentGame.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/9/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

public class CurrentGame {

    public static var shepard: Shepard = {
        var shepard = Shepard(game: .Game1) // or load from NSUserDefaults or something?
        shepard.onChange.listen(CurrentGame.self) { (shepard) in
            CurrentGame.onCurrentShepardChange.fire(true)
        }
        return shepard
    }()
//    {
//        didSet {
//            if shepard != oldValue && oldValue.hasUnsavedData {
//                SavedData.saveShepard(oldValue)
//            }
//        }
//    }
    
    public class func changeGame(newGame: Shepard.Game) {
        let oldGame = CurrentGame.shepard.game
        var newGameSameShepard = false
        let index: Int = {
            if let foundIndex = SavedData.shepardSets.indexOf({ $0.match(CurrentGame.shepard) }) {
                SavedData.saveShepard(CurrentGame.shepard)
                newGameSameShepard = true
                return foundIndex
            } else {
                var newShepard = SavedData.addNewShepard(newGame, shepard: Shepard(game: newGame))
                newShepard.hasUnsavedData = true
                return SavedData.shepardSets.count - 1
            }
        }()
        if let foundShepard = SavedData.shepardSets[index].getGame(newGame) {
            CurrentGame.changeShepard(foundShepard)
        } else {
            var newShepard = Shepard(game: newGame)
            if newGameSameShepard {
                //ask first?
                newShepard.setData(CurrentGame.shepard.getData(), source: .GameConversion(priorGame: oldGame))
            }
            SavedData.saveShepard(newShepard, atIndex: index)
            CurrentGame.changeShepard(newShepard)
        }
    }
    
    public class func changeShepard(newShepard: Shepard) {
        CurrentGame.shepard.setData(newShepard.getData(), source: .SavedData)
        SavedData.markShepardAsLastPlayed(newShepard)
        CurrentGame.onCurrentShepardChange.fire(true)
    }
    
//MARK: Listeners
    
    // notifies of any change to current shepard (which is really any change to any shepard, since you can only change the current one)
    public static let onCurrentShepardChange = Signal<(Bool)>()
}

extension CurrentGame: SerializableDataType {

    public func getData() -> SerializableData {
        var list = [String: SerializableDataType?]()
        list["shepard"] = CurrentGame.shepard.uuid
        return SerializableData(list)
    }
    
    public func setData(data: SerializableData) {
        guard let uuid = data["shepard"]?.string
        else {
            return
        }
        if let shepard = SavedData.findShepard(uuid) {
            CurrentGame.changeShepard(shepard)
        }
    }
    
}