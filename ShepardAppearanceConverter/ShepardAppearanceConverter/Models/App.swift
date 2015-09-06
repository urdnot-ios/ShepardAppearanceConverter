//
//  App.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/30/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

//
// Right now it loses data on simulator stop (or maybe device crash?), because it isn't saving latest game until app closed.
// Maybe I want to save more?
//
// Delete is not working :/
//
// New Games appear on the list delayed by one game :/
//

public class App {

    public static var currentGame = GameSequence() {
        didSet {
            resetShepardListener()
        }
    }
    
    public static var allGames: Games = {
        return Games(startingGame: App.currentGame)
    }()
    
    public init() {}
    
    public required init(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws { // protocol conformance SerializedDataRetrievable
        try setData(serializedData: data, origin: origin)
    }
    
    public class func addNewGame() {
        currentGame.saveAnyChanges()
        let newGame = GameSequence()
        allGames.add(newGame)
        currentGame = newGame
        save()
    }
    
    public class func changeGame(game: GameSequence) {
        currentGame.saveAnyChanges()
        currentGame = game
    }
    
    public class func deleteGame(uuid uuid: String) -> Bool {
        let isDeleted = allGames.delete(uuid: uuid)
        if isDeleted {
            // pick a new current game if necessary:
            if uuid == currentGame.uuid, let newUuid = allGames.last?.uuid, let game = GameSequence(uuid: newUuid) {
                currentGame = game
            }
            save()
        }
        return isDeleted
    }
    
    public class func resetShepardListener() {
        currentGame.shepard.onChange.listen(App.self) { (shepard) in
            onCurrentShepardChange.fire(true)
        }
        onCurrentShepardChange.fire(true)
    }
}
    
//MARK: Notifications

extension App {
    
    public static let onCurrentShepardChange = Signal<(Bool)>()
    public static let onShepardsListChange = Signal<(Bool)>()
}

//MARK: App Open/Close

extension App {
        
    public class func store() {
        save()
    }
    
    public class func retrieve() {
        get()
    }
    
}
    
//MARK: Saving/Retrieving Data

extension App: SerializedDataStorable {

    public func getData(target target: SerializedDataOrigin = .LocalStore) -> SerializedData {
        var list = [String: SerializedDataStorable?]()
        list["all_games"] = App.allGames.getData(target: target)
        list["current_game_uuid"] = App.currentGame.uuid
        return SerializedData(list)
    }
    
}

extension App: SerializedDataRetrievable {
    
    public func setData(data: SerializedData, origin: SerializedDataOrigin = .LocalStore) {
        if let data = data["all_games"] {
            App.allGames.setData(data, origin: origin)
        }
        if let currentGameUuid = data["current_game_uuid"]?.string,
           let game = GameSequence(uuid: currentGameUuid) {
           App.currentGame = game
        }
    }
    
    public func setData(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws {
        setData(try SerializedData(serializedData: data), origin: origin)
    }
    
}



