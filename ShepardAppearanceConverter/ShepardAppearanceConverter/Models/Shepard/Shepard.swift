//
//  Shepard.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/19/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

public struct Shepard {

    public static let DefaultSurname = "Shepard"
    
    public init(game: Game = .Game1) {
        self.game = game
        appearance = Appearance(game: game)
    }

//MARK: Properties

    public private(set) var uuid = "\(NSUUID().UUIDString)"
    
    public private(set) var createdDate = NSDate()
    
    public private(set) var modifiedDate = NSDate()
    
    public private(set) var game: Game 
    
    public var gender = Gender.Male {
        didSet{
            let oldDontMarkUpdated = dontMarkUpdated
            dontMarkUpdated = true // only trigger update once
            switch gender {
            case .Male:
                if name == .DefaultFemaleName {
                    name = .DefaultMaleName
                }
                if photo == .DefaultFemalePhoto {
                    photo = .DefaultMalePhoto
                }
                appearance.gender = gender
            case .Female:
                if name == .DefaultMaleName {
                    name = .DefaultFemaleName
                }
                if photo == .DefaultMalePhoto {
                    photo = .DefaultFemalePhoto
                }
                appearance.gender = gender
            }
            dontMarkUpdated = oldDontMarkUpdated
            markUpdated()
        }
    }
    
    public var name = Name.DefaultMaleName { didSet{
    markUpdated()
    } }
    // special setter for taking strings:
    public mutating func setName(name: String?) {
        if name == Name.DefaultMaleName.stringValue || (name == nil && gender == .Male) {
            self.name = .DefaultMaleName
        }
        if name == Name.DefaultFemaleName.stringValue || (name == nil && gender == .Female)  {
            self.name = .DefaultFemaleName
        } else if name != nil {
            self.name = .Custom(name: name!)
        }
    }
    public var fullName: String { return "\(name.stringValue!) Shepard" }
    
    public var photo = Photo.DefaultMalePhoto { didSet{
    markUpdated()
    } }
    // special setter for taking UIImage:
    public mutating func setPhoto(image: UIImage) -> Bool {
        let fileName = "MyShepardPhoto\(uuid)"
        if SavedData.saveImageToDocuments(fileName, image: image) {
            photo = .Custom(file: fileName)
            return true
        }
        return false
    }

    public var appearance: Appearance { didSet{
    markUpdated()
    } }
    
    public var origin = Origin.Earthborn { didSet{ 
    markUpdated()
    } }
    
    public var reputation = Reputation.SoleSurvivor { didSet{ 
    markUpdated()
    } }
    
    public var classTalent = ClassTalent.Soldier { didSet{ 
    markUpdated()
    } }
    
    public var title: String {
        return "\(origin.rawValue) \(reputation.rawValue) \(classTalent.rawValue)"
    }
    
//MARK: Listeners

    internal var dontMarkUpdated = false
    internal var hasUnsavedData = false
    
    public mutating func markUpdated(fireChangeListener: Bool = false) {
        if !dontMarkUpdated {
            self.modifiedDate = NSDate()
            hasUnsavedData = true
            // for some reason, the changes aren't propogated up to CurrentGame.Shepard (despite value type), unless we do this delayed call?
            Delay.bySeconds(0, { self.onChange.fire(self) })
        }
    }
    
    /// Don't use this. Use CurrentGame.onCurrentShepardChange instead.
    internal let onChange = Signal<(Shepard)>()
}


//MARK: Save/Retrieve Data

extension Shepard: SerializableDataType {

    public init(data: SerializableData) {
        let game = Game(rawValue: data["game"]?.string ?? "0") ?? .Game1
        self.init(game: game)
        setData(data)
    }
    
    ///
    /// Extracts all data from this shepard and stores it in a dictionary.
    ///
    public func getData() -> SerializableData {
        var list = [String: SerializableDataType?]()
        list["uuid"] = uuid
        list["created_date"] = createdDate
        list["modified_date"] = modifiedDate
        list["game"] = game.rawValue
        list["gender"] = gender == .Male ? "M" : "F"
        list["name"] = name.stringValue
        list["appearance"] = appearance.format()
        list["photo"] = photo.stringValue
        list["origin"] = origin.rawValue
        list["reputation"] = reputation.rawValue
        list["class"] = classTalent.rawValue
        return SerializableData(list)
    }
    
    public mutating func setData(data: SerializableData) {
        setData(data, source: .SavedData)
    }
    
    ///
    /// Creates a shepard with a dictionary of data. Can be from saved values, or from a previous game.
    /// Values general to all shepards within a set should be placed in setCommonData instead.
    ///
    public mutating func setData(data: SerializableData, source: SetDataSource) {
        //don't first any changes from these functions - they aren't true changes, just loading data from elsewhere
        let oldDontMarkUpdated = dontMarkUpdated
        dontMarkUpdated = true
        
        let gender = data["gender"]?.string == "M" ? Gender.Male : Gender.Female // just for local use
        
        if case let .GameConversion(oldGame) = source {
            var appearance = Appearance(data["appearance"]?.string ?? "", fromGame: oldGame, withGender: gender)
            appearance.convert(toGame: game)
            self.appearance = appearance
        } else {
            self.appearance = Appearance(data["appearance"]?.string ?? "", fromGame: game, withGender: gender)
        }
        
        classTalent = ClassTalent(rawValue: data["class"]?.string ?? "") ?? classTalent
        
        setCommonData(data)
        
        if source == .SavedData {
            self.uuid = data["uuid"]?.string ?? uuid
            self.game = Game(rawValue: data["game"]?.string ?? "0") ?? .Game1
            self.createdDate = data["created_date"]?.date ?? NSDate()
            self.modifiedDate = data["modified_date"]?.date ?? NSDate()
        }
        
        dontMarkUpdated = oldDontMarkUpdated
    }
    
    ///
    /// Data shared by all shepards in a Set.
    /// Put souvenirs/achievements here?
    ///
    public mutating func setCommonData(data: SerializableData) {
        //don't first any changes from these functions - they aren't true changes, just loading data from elsewhere
        let oldDontMarkUpdated = dontMarkUpdated
        dontMarkUpdated = true
    
        let gender = data["gender"]?.string == "M" ? Gender.Male : Gender.Female
        
        setName(data["name"]?.string)
        
        origin = Origin(rawValue: data["origin"]?.string ?? "") ?? origin
        reputation = Reputation(rawValue: data["reputation"]?.string ?? "") ?? reputation
        
        // do gender last (it changes stuff):
        self.gender = gender
        
        dontMarkUpdated = oldDontMarkUpdated
    }
}


//MARK: Equatable

extension Shepard: Equatable {}

public func ==(a: Shepard, b: Shepard) -> Bool {
    return a.uuid == b.uuid
}


//MARK: SetDataSource

extension Shepard {
    public enum SetDataSource: Equatable {
        case SavedData, GameConversion(priorGame: Game)
    }
}

public func ==(a: Shepard.SetDataSource, b: Shepard.SetDataSource) -> Bool {
    switch (a, b) {
    case (.SavedData, .SavedData): return true
    case (.GameConversion(let a), .GameConversion(let b)) where a == b: return true
    default: return false
    }
}

