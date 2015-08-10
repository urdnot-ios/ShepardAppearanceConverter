//
//  SavedData.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/30/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import Foundation

public class SavedData {
    
    public static var shepards = [Shepard]()
    
//MARK: Saving/Retrieving Data

    /**
        get/set data which it can read back in to reconstruct User.
    
        Xcode build times out on AnyObject, so have to be very specific on type.
    */
    public class func getData() -> HTTPData {
        // Keep all values to non-optional Value type or NSNull
        // (This is tortured because generic arrays of any large size like [String: AnyObject] freeze up Xcode during build)
        var list = [String: Any]()
        list["shepards"] = shepards.map { $0.getData() }
        return HTTPData(list)
    }
    
    public class func setData(data: HTTPData) {
        shepards = []
        for shepardData in data["shepards"].array {
            shepards.append(Shepard(data: shepardData))
        }
    }

    public static let nsUserDefaultsKey = "saved_data"
        
    public class func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(SavedData.getData().jsonString, forKey: SavedData.nsUserDefaultsKey)
    }
    
    public class func retrieve() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let data = defaults.objectForKey(SavedData.nsUserDefaultsKey) as? String {
            SavedData.setData(HTTPData(jsonString: data))
        }
    }
}