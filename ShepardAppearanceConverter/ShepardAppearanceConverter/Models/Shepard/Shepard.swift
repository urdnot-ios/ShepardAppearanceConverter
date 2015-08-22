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
        _game = game
        _appearance = Appearance(game: game)
    }

//MARK: Properties

    internal var _uuid = "\(NSUUID().UUIDString)"
    public var uuid: String { return _uuid }
    
    internal var _createdDate = NSDate()
    public var createdDate: NSDate { return _createdDate }
    
    internal var _modifiedDate = NSDate()
    public var modifiedDate: NSDate { return _modifiedDate }
    
    internal var _game: Game
    public var game: Game { return _game }
    
    internal var _gender = Gender.Male { didSet{ markUpdated() } }
    public var gender: Gender { return _gender }
    
    internal var _name = Name.DefaultMaleName { didSet{ markUpdated() } }
    public var name: Name { return _name }
    public var fullName: String { return "\(name.stringValue!) Shepard" }
    
    internal var _photo = Photo.DefaultMalePhoto { didSet{ markUpdated() } }
    public var photo: Photo { return _photo }

    internal var _appearance: Appearance { didSet{ markUpdated() } }
    public var appearance: Appearance { return _appearance }
    
    public var origin = Origin.Earthborn { didSet{ markUpdated() } }
    
    public var reputation = Reputation.SoleSurvivor { didSet{ markUpdated() } }
    
    public var classTalent = ClassTalent.Soldier { didSet{ markUpdated() } }
    
    public var title: String {
        return "\(origin.rawValue) \(reputation.rawValue) \(classTalent.rawValue)"
    }
    
//MARK: Supporting Functions
    
    public mutating func setGender(gender: Gender) {
        _gender = gender
        switch gender {
        case .Male:
            if _name == .DefaultFemaleName {
                _name = .DefaultMaleName
            }
            if _photo == .DefaultFemalePhoto {
                _photo = .DefaultMalePhoto
            }
            _appearance.gender = gender
        case .Female:
            if _name == .DefaultMaleName {
                _name = .DefaultFemaleName
            }
            if _photo == .DefaultMalePhoto {
                _photo = .DefaultFemalePhoto
            }
            _appearance.gender = gender
        }
    }

    public mutating func setName(name: String?) {
        if name == Name.DefaultMaleName.stringValue || (name == nil && gender == .Male) {
            _name = .DefaultMaleName
        }
        if name == Name.DefaultFemaleName.stringValue || (name == nil && gender == .Female)  {
            _name = .DefaultFemaleName
        } else if name != nil {
            _name = .Custom(name: name!)
        }
    }
    
    public mutating func setPhoto(image: UIImage) -> Bool {
        let fileName = "MyShepardPhoto\(_uuid)"
        if SavedData.saveImageToDocuments(fileName, image: image) {
            _photo = .Custom(file: fileName)
            return true
        }
        return false
    }
    
    public mutating func setAppearance(appearance: Appearance) {
        _appearance = appearance
    }
    
//MARK: Listeners

    internal var dontMarkUpdated = false
    internal var hasUnsavedData = false
    
    public mutating func markUpdated() {
        if !dontMarkUpdated {
            _modifiedDate = NSDate()
            hasUnsavedData = true
            // for some reason, the changes aren't propogated up to CurrentGame.Shepard (despite value type), unless we do this delayed call?
            Delay.bySeconds(0, { self.onChange.fire(self) })
        }
    }
    
    /// Don't use this. Use CurrentGame.onCurrentShepardChange instead.
    internal let onChange = Signal<(Shepard)>()
}


extension Shepard: Equatable {}
public func ==(a: Shepard, b: Shepard) -> Bool {
    return a._uuid == b._uuid
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
        list["uuid"] = _uuid
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
        if source == .SavedData {
            dontMarkUpdated = true
            _uuid = data["uuid"]?.string ?? _uuid
            _game = Game(rawValue: data["game"]?.string ?? "0") ?? .Game1
            _createdDate = data["created_date"]?.date ?? NSDate()
            _modifiedDate = data["modified_date"]?.date ?? NSDate()
        }
        
        let gender = data["gender"]?.string == "M" ? Gender.Male : Gender.Female
        
        if case let .GameConversion(oldGame) = source {
            var appearance = Appearance(data["appearance"]?.string ?? "", fromGame: oldGame, withGender: gender)
            appearance.convert(toGame: game)
            setAppearance(appearance)
        } else {
            setAppearance(Appearance(data["appearance"]?.string ?? "", fromGame: game, withGender: gender))
        }
        
        classTalent = ClassTalent(rawValue: data["class"]?.string ?? "") ?? classTalent
        
        setCommonData(data)
        
        dontMarkUpdated = false
    }
    
    ///
    /// Data shared by all shepards in a Set.
    /// Put souvenirs/achievements here?
    ///
    public mutating func setCommonData(data: SerializableData) {
    
        let gender = data["gender"]?.string == "M" ? Gender.Male : Gender.Female
        
        setName(data["name"]?.string)
        
        origin = Origin(rawValue: data["origin"]?.string ?? "") ?? origin
        reputation = Reputation(rawValue: data["reputation"]?.string ?? "") ?? reputation
        
        // do gender last (it changes stuff):
        setGender(gender)
    }
}



//MARK: Supporting Data types

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

