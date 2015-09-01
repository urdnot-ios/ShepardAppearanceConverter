//
//  SavedGames.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/30/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

public class SavedGames {

    public init() {} // sometimes we need an instantiated version for SerializedDataStorable uses
    
    public required init(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws { // protocol conformance SerializedDataRetrievable
        try setData(serializedData: data, origin: origin)
    }
    
    private static var _shepardsSequences: [ShepardsSequence] = []
    
    public static var shepardsSequences: [ShepardsSequence] {
        if CurrentGame.shepard.hasUnSavedGames {
            saveShepard(CurrentGame.shepard)
        }
        return _shepardsSequences
    }
    
    public class func addNewShepard(game: Shepard.Game = .Game1, shepard: Shepard? = nil) -> Shepard {
        let newShepard = shepard != nil ? shepard! : Shepard(game: game)
        let shepardGames = ShepardsSequence(game: game, shepard: newShepard)
        _shepardsSequences.append(shepardGames)
        return newShepard
    }
    
    public class func findShepard(uuid: String) -> Shepard? {
        for shepardsSequence in _shepardsSequences {
            if let shepard = shepardsSequence.find(uuid) {
                return shepard
            }
        }
        return nil
    }
    
    public class func markShepardAsLastPlayed(shepard: Shepard) {
        if let foundIndex = _shepardsSequences.indexOf({ $0.match(shepard) }) {
            SavedGames._shepardsSequences[foundIndex].lastPlayedGame = shepard.game
        }
    }
    
    public class func deleteShepard(shepard: Shepard) -> Bool {
        if let foundIndex = _shepardsSequences.indexOf({ $0.match(shepard) }) {
            let shepardSequence = _shepardsSequences.removeAtIndex(foundIndex)
            return shepardSequence.delete()
        }
        return false
    }
    
    public class func saveShepard(var shepard: Shepard, atIndex index: Int? = nil) {
        // value types are hard to sync up - have to copy changes back into array
        guard let useIndex: Int = {
            if let foundIndex = index where foundIndex < _shepardsSequences.count ?? 0 {
                return foundIndex
            } else if let foundIndex = _shepardsSequences.indexOf({ $0.match(shepard) }) {
                return foundIndex
            }
            return nil
        }() else { return }
        
        shepard.hasUnSavedGames = false
        _shepardsSequences[useIndex].setGame(shepard.game, shepard: shepard)
        if let storedShepard = _shepardsSequences[useIndex].getGame(shepard.game) {
            storedShepard.save()
        } else {
            // return error?
        }
    }

    public static let nsUserDefaultsKey = "saved_data"
        
    public class func store() {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setObject(SavedGames().getData(target: .LocalStoreCombinedWithDatabase).serializedData, forKey: nsUserDefaultsKey)
////        defaults.synchronize()
    }
    
    public class func retrieve() {
        _shepardsSequences = ShepardsSequence.getAll()
        if let currentGame = CurrentGame.get() {
            CurrentGame.setData(currentGame.getData(), origin: .Database)
        }
//        let defaults = NSUserDefaults.standardUserDefaults()
//        if let data = defaults.objectForKey(nsUserDefaultsKey) as? String {
//            do {
//                let mixedData = try SerializedData(jsonString: data)
//                SavedGames().setData(mixedData, origin: .LocalStoreCombinedWithDatabase)
//                return
//            } catch {}
//        }
//        SavedGames().setData(SerializedData())
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

extension SavedGames {
    
    public static let onShepardsListChange = Signal<(Bool)>()
}
    
//MARK: Saving/Retrieving Data

extension SavedGames: SerializedDataStorable {

    public func getData(target target: SerializedDataOrigin = .LocalStore) -> SerializedData {
        SavedGames.saveShepard(CurrentGame.shepard)
        var list = [String: SerializedDataStorable?]()
        if target == .LocalStore {
            list["shepards_sequences"] = SerializedData(SavedGames._shepardsSequences.map { $0.getData() })
            list["current_game"] = CurrentGame.getData()
        } else if target == .Database {
        }
        return SerializedData(list)
    }
    
}

extension SavedGames: SerializedDataRetrievable {
    
    public func setData(data: SerializedData, origin: SerializedDataOrigin = .LocalStore) {
        if origin == .LocalStore {
            SavedGames._shepardsSequences = (data["shepards_sequences"]?.array ?? []).map { ShepardsSequence(data: $0) }
            CurrentGame.setData(data["current_game"] ?? SerializedData())
            if SavedGames._shepardsSequences.isEmpty {
                SavedGames.addNewShepard(CurrentGame.shepard.game, shepard: CurrentGame.shepard)
            }
        } else if origin == .Database {
        }
    }
    
    public func setData(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws {
        setData(try SerializedData(serializedData: data), origin: origin)
    }
    
}
