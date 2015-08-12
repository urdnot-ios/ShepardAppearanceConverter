//
//  SavedData.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/30/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

public class SavedData {
    
    public static var shepards: [[Shepard.Game: Shepard]] = []
    
    public class func addNewShepard(game: Shepard.Game = .Game1) -> Shepard {
        let newShepard = Shepard(game: game)
        let shepardGames = [game: newShepard]
        shepards.append(shepardGames)
        return newShepard
    }
    
    public class func findShepard(uuid: String) -> Shepard? {
        return shepards.reduce([], combine: { $0 + $1.filter { $1.uuid == uuid } }).first?.1
    }
    
    public class func saveShepard(shepard: Shepard) {
        if let foundIndex = shepards.indexOf({ $0[shepard.game] == shepard }) {
            shepards[foundIndex][shepard.game] = shepard
        }
    }

    public static let nsUserDefaultsKey = "saved_data"
        
    public class func store() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(getData().jsonString, forKey: nsUserDefaultsKey)
//        defaults.synchronize()
    }
    
    public class func retrieve() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let data = defaults.objectForKey(nsUserDefaultsKey) as? String {
            setData(HTTPData(jsonString: data))
        }
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
    
//MARK: Saving/Retrieving Data

extension SavedData {

    public class func getData() -> HTTPData {
        saveShepard(CurrentGame.shepard)
        var list = [String: HTTPData]()
        list["shepards"] = HTTPData(shepards.map { HTTPData(Dictionary($0.map { ($0.rawValue, $1.getData()) })) })
        list["current_game"] = CurrentGame.getData()
        return HTTPData(list)
    }
    
    public class func setData(data: HTTPData) {
        shepards = data["shepards"].array.map {
            Dictionary( $0.dictionary.map { (Shepard.Game(rawValue: $0 ?? "0") ?? .Game1, Shepard(data: $1)) })
        }
        CurrentGame.setData(data["current_game"])
    }
}