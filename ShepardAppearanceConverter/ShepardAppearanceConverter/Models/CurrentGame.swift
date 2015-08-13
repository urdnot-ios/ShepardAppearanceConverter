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
        return Shepard(game: .Game1) // or load from NSUserDefaults or something?
    }() {
        didSet {
            print("X")
        }
    }
    
    public class func changeGame(newGame: Shepard.Game) {
        let oldGame = CurrentGame.shepard.game
        var newGameSameShepard = false
        let index: Int = {
            if let foundIndex = SavedData.shepards.indexOf({ $0.match(CurrentGame.shepard) }) {
                SavedData.saveShepard(CurrentGame.shepard)
                newGameSameShepard = true
                return foundIndex
            } else {
                let newShepardSet = ShepardSet(game: newGame, shepard: Shepard(game: newGame))
                SavedData.shepards.append(newShepardSet)
                return SavedData.shepards.count - 1
            }
        }()
        if let foundShepard = SavedData.shepards[index].getGame(newGame) {
            CurrentGame.shepard = foundShepard
        } else {
            var newShepard = Shepard(game: newGame)
            if newGameSameShepard {
                //ask first?
                newShepard.setData(CurrentGame.shepard.getData(), source: .GameConversion(priorGame: oldGame))
            }
            CurrentGame.shepard = newShepard
            SavedData.shepards[index].addGame(newGame, shepard: newShepard)
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