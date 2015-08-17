//
//  Shepard.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/19/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

public struct Shepard: Equatable {

    public static let DefaultSurname = "Shepard"
    
    public init(game: Game = .Game1) {
        _game = game
        _appearance = Appearance(game: game)
    }

//MARK: Properties
    internal var dontMarkUpdated = false
    internal var hasUnsavedData = false


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
    
    public mutating func markUpdated() {
        if !dontMarkUpdated {
            _modifiedDate = NSDate()
            hasUnsavedData = true
        }
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
    
}

public func ==(a: Shepard, b: Shepard) -> Bool {
    return a._uuid == b._uuid
}



//MARK: Save/Retrieve Data

extension Shepard {

    public init(data: HTTPData) {
        let game = Game(rawValue: data["game"].string ?? "0") ?? .Game1
        self.init(game: game)
        setData(data)
    }
    
    public func getData() -> HTTPData {
        var list = [String: AnyObject]()
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
        return HTTPData(list)
    }
    
    public mutating func setData(data: HTTPData, source: SetDataSource = .SavedData) {
        if source == .SavedData {
            dontMarkUpdated = true
            _uuid = data["uuid"].string ?? _uuid
            _game = Game(rawValue: data["game"].string ?? "0") ?? .Game1
            _createdDate = data["created_date"].date ?? NSDate()
            _modifiedDate = data["modified_date"].date ?? NSDate()
        }
        
        setName(data["name"].string)
        
        if let photoName = data["photo"].string {
            if photoName == Photo.DefaultMalePhoto.stringValue, let photo = Photo.DefaultMalePhoto.image() {
                setPhoto(photo)
            } else if photoName == Photo.DefaultFemalePhoto.stringValue, let photo = Photo.DefaultFemalePhoto.image() {
                setPhoto(photo)
            } else if photoName.stringFrom(0, to: 7) == "Custom:", let photo = SavedData.loadImageFromDocuments(photoName.stringFrom(7)) {
                setPhoto(photo)
            }
        }
        
        if case let .GameConversion(oldGame) = source {
            var appearance = Appearance(data["appearance"].string ?? "", fromGame: oldGame, withGender: gender)
            appearance.convert(toGame: game)
            setAppearance(appearance)
        } else {
            setAppearance(Appearance(data["appearance"].string ?? "", fromGame: game, withGender: gender))
        }
        
        origin = Origin(rawValue: data["origin"].string ?? "") ?? origin
        reputation = Reputation(rawValue: data["reputation"].string ?? "") ?? reputation
        classTalent = ClassTalent(rawValue: data["class"].string ?? "") ?? classTalent
        
        // do gender last (it changes stuff):
        setGender(data["gender"].string == "M" ? .Male : .Female)
        
        dontMarkUpdated = false
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

