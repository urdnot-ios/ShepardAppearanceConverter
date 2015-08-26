//
//  SavedData.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/30/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

public class SavedData {
    
    private static var shepards: [ShepardSet] = []
    
    public static var shepardSets: [ShepardSet] {
        if CurrentGame.shepard.hasUnsavedData {
            saveShepard(CurrentGame.shepard)
        }
        return shepards
    }
    
    public class func addNewShepard(game: Shepard.Game = .Game1, shepard: Shepard? = nil) -> Shepard {
        let newShepard = shepard != nil ? shepard! : Shepard(game: game)
        let shepardGames = ShepardSet(game: game, shepard: newShepard)
        shepards.append(shepardGames)
        return newShepard
    }
    
    public class func findShepard(uuid: String) -> Shepard? {
        for shepardSet in shepards {
            if let shepard = shepardSet.find(uuid) {
                return shepard
            }
        }
        return nil
    }
    
    public class func markShepardAsLastPlayed(shepard: Shepard) {
        if let foundIndex = shepards.indexOf({ $0.match(shepard) }) {
            SavedData.shepards[foundIndex].lastPlayedGame = shepard.game
        }
    }
    
    public class func deleteShepard(shepard: Shepard) -> Bool {
        if let foundIndex = shepards.indexOf({ $0.match(shepard) }) {
            shepards.removeAtIndex(foundIndex)
            return true
        }
        return false
    }
    
    public class func saveShepard(var shepard: Shepard, atIndex index: Int? = nil) {
        if let foundIndex = index where foundIndex < shepards.count ?? 0 {
            shepards[foundIndex].setGame(shepard.game, shepard: shepard)
            shepard.hasUnsavedData = false
        } else if let foundIndex = shepards.indexOf({ $0.match(shepard) }) {
            shepards[foundIndex].setGame(shepard.game, shepard: shepard)
            shepard.hasUnsavedData = false
        }
    }

    public static let nsUserDefaultsKey = "saved_data"
        
    public class func store() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(SavedData().getData().jsonString, forKey: nsUserDefaultsKey)
//        defaults.synchronize()
    }
    
    public class func retrieve() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let data = defaults.objectForKey(nsUserDefaultsKey) as? String {
            do {
                let mixedData = try SerializableData(jsonString: data)
                SavedData().setData(mixedData)
                return
            } catch {}
        }
        SavedData().setData(SerializableData())
    }
    
    public class func loadImageFromDocuments(fileName: String) -> UIImage? {
        if let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]).first {
            return UIImage(contentsOfFile: documentsDirectory.stringByAppendingPathComponent(fileName))
        }
        return nil
    }
    
    public class func saveImageToDocuments(fileName: String, image: UIImage) -> Bool {
        if let imageData = UIImagePNGRepresentation(image),
           let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]).first {
            imageData.writeToFile(documentsDirectory.stringByAppendingPathComponent(fileName), atomically: true)
            return true
        }
        return false
    }
}
    
//MARK: Notifications

extension SavedData {
    
    public static let onShepardsListChange = Signal<(Bool)>()
}
    
//MARK: Saving/Retrieving Data

extension SavedData: SerializableDataType {

    public func getData() -> SerializableData {
        SavedData.saveShepard(CurrentGame.shepard)
        var list = [String: SerializableDataType?]()
        list["shepards"] = SerializableData(SavedData.shepards.map { $0.getData() })
        list["current_game"] = CurrentGame().getData()
        return SerializableData(list)
    }
    
    public func setData(data: SerializableData) {
        SavedData.shepards = (data["shepards"]?.array ?? []).map { ShepardSet(data: $0) }
        CurrentGame().setData(data["current_game"] ?? SerializableData())
        if SavedData.shepards.isEmpty {
            SavedData.addNewShepard(CurrentGame.shepard.game, shepard: CurrentGame.shepard)
        }
    }
}
