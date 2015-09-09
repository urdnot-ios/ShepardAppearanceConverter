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

    public static var dataVersion = 0.01

    public static var currentGame = GameSequence()
    
    public static var allGames: Games = {
        return Games(startingGame: App.currentGame)
    }()
    
    public init() {}
    
    public required init(serializedData data: String) throws { // protocol conformance SerializedDataRetrievable
        try setData(serializedData: data)
    }
    
    public class func addNewGame() {
        currentGame.saveAnyChanges()
        let newGame = GameSequence()
        allGames.add(newGame)
        currentGame = newGame
        resetShepardListener()
        save()
    }
    
    public class func changeGame(game: GameSequence) {
        currentGame.saveAnyChanges()
        currentGame = game
        resetShepardListener()
        save()
    }
    
    public class func deleteGame(uuid uuid: String) -> Bool {
        let isDeleted = allGames.delete(uuid: uuid)
        if isDeleted {
            // pick a new current game if necessary:
            if uuid == currentGame.uuid, let newUuid = allGames.last?.uuid, let game = GameSequence(uuid: newUuid) {
                currentGame = game
                resetShepardListener()
            }
            save()
        }
        return isDeleted
    }
    
    public class func resetShepardListener() {
        currentGame.shepard.onChange.listen(App.self) { (shepard) in
            onCurrentShepardChange.fire(true)
        }
        Delay.bySeconds(0, { self.onCurrentShepardChange.fire(true) })
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
        if get() == nil {
            // first time opening app
            App().setData(SerializedData())
            resetShepardListener()
            save()
        }
    }
    
}
    
//MARK: Saving/Retrieving Data

extension App: SerializedDataStorable {

    public func getData() -> SerializedData {
        var list = [String: SerializedDataStorable?]()
        list["lastDataVersion"] = App.dataVersion
        list["allGames"] = App.allGames.getData()
        list["currentGameUuid"] = App.currentGame.uuid
        return SerializedData(list)
    }
    
}

extension App: SerializedDataRetrievable {
    
    public func setData(data: SerializedData) {
        let lastDataVersion = data["lastDataVersion"]?.double ?? 0.00
        if lastDataVersion != App.dataVersion {
//           CoreDataSync().syncFrom(lastDataVersion, to: App.dataVersion)
        }
        
        if let data = data["allGames"] {
            App.allGames.setData(data)
        }
        if let currentGameUuid = data["currentGameUuid"]?.string,
           let game = GameSequence(uuid: currentGameUuid) {
           App.currentGame = game
        }
    }
    
    public func setData(serializedData data: String) throws {
        setData(try SerializedData(serializedData: data))
    }
    
}



