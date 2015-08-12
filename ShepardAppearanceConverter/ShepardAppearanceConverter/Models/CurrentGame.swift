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
        return SavedData.addNewShepard() // or load from NSUserDefaults or something?
    }() {
        didSet {
            print("X")
        }
    }
    
    public class func changeGame(newGame: Shepard.Game) {
        let oldGame = CurrentGame.shepard.game
        var newGameSameShepard = false
        let index: Int = {
            if let foundIndex = SavedData.shepards.indexOf({ $0[oldGame] == CurrentGame.shepard }) {
                SavedData.shepards[foundIndex][oldGame] = CurrentGame.shepard // save old shepard values
                newGameSameShepard = true
                return foundIndex
            } else {
                let newShepardSet: [Shepard.Game: Shepard] = [:]
                SavedData.shepards.append(newShepardSet)
                return SavedData.shepards.count - 1
            }
        }()
        if let foundShepard = SavedData.shepards[index][newGame] {
            CurrentGame.shepard = foundShepard
        } else {
            var newShepard = Shepard(game: newGame)
            if newGameSameShepard {
                //ask first?
                newShepard.setData(CurrentGame.shepard.getData(), source: .GameConversion(priorGame: oldGame))
            }
            CurrentGame.shepard = newShepard
            SavedData.shepards[index][newGame] = CurrentGame.shepard
        }
    }
}

extension CurrentGame {

    public class func getData() -> HTTPData {
        var list = [String: AnyObject]()
        list["shepard"] = shepard.uuid
        return HTTPData(list)
    }
    
    public class func setData(data: HTTPData) {
        guard let uuid = data["shepard"].string
        else {
            return
        }
        if let shepard = SavedData.findShepard(uuid) {
            CurrentGame.shepard = shepard
        }
    }
    
}