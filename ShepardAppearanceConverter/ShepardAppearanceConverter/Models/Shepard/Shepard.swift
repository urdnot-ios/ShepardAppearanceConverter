//
//  Shepard.swift
//  MassEffectTracker
//
//  Created by Emily Ivie on 7/19/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

public struct Shepard {

    public static let DefaultSurname = "Shepard"
    
    public init(sequenceUuid: String, gameVersion: GameSequence.GameVersion = .Game1) {
        self.sequenceUuid = sequenceUuid
        self.gameVersion = gameVersion
        appearance = Appearance(gameVersion: gameVersion)
        markChanged()
    }

//MARK: Properties

    public internal(set) var sequenceUuid: String

    public private(set) var uuid = "\(NSUUID().UUIDString)"

    public private(set) var createdDate = NSDate()
    public var modifiedDate = NSDate()
    
    public private(set) var gameVersion: GameSequence.GameVersion
    
    public var gender = Gender.Male {
        didSet{
            if oldValue != gender {
                hasSequenceChanges = true
                
                let oldNotifyChanges = notifyChanges
                notifyChanges = false // only trigger update once
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
                notifyChanges = oldNotifyChanges
                markChanged()
            }
        }
    }
    
    public var name = Name.DefaultMaleName { 
        didSet{
            if oldValue != name {
                markChanged()
            }
        }
    }
    
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
    
    public var photo = Photo.DefaultMalePhoto { 
        didSet{
            if oldValue != photo {
                markChanged()
            }
        }
    }
    
    // special setter for taking UIImage:
    public mutating func setPhoto(image: UIImage) -> Bool {
        if let photo = Photo.create(image, forShepard: self) {
            self.photo = photo
            return true
        }
        return false
    }

    public var appearance: Appearance { 
        didSet{
            if oldValue != appearance {
                markChanged()
            }
        }
    }
    
    public var origin = Origin.Earthborn {
        didSet{
            if oldValue != origin {
                hasSequenceChanges = true
                markChanged()
            }
        }
    }
    
    public var reputation = Reputation.SoleSurvivor {
        didSet{
            if oldValue != reputation {
                hasSequenceChanges = true
                markChanged()
            }
        }
    }
    
    public var classTalent = ClassTalent.Soldier { 
        didSet{
            if oldValue != classTalent {
                markChanged()
            }
        }
    }
    
    public var title: String {
        return "\(origin.rawValue) \(reputation.rawValue) \(classTalent.rawValue)"
    }
    
//MARK: Listeners

    internal var notifyChanges = true
    internal var hasUnsavedChanges = false
    internal var hasSequenceChanges = false
    
    public mutating func markChanged(fireChangeListener: Bool = false) {
        if notifyChanges {
            self.modifiedDate = NSDate()
            hasUnsavedChanges = true
            // for some reason, the changes aren't propogated up to CurrentGame.Shepard (despite value type), unless we do this delayed call?
            Delay.bySeconds(0, { self.onChange.fire(self) })
        }
    }
    
    /// Don't use this. Use App.onCurrentShepardChange instead.
    internal let onChange = Signal<(Shepard)>()
}


//MARK: Equatable

extension Shepard: Equatable {}

public func ==(a: Shepard, b: Shepard) -> Bool {
    return a.uuid == b.uuid
}


//MARK: Save/Retrieve Data

extension Shepard: SerializedDataStorable {

    public func getData() -> SerializedData {
        var list = [String: SerializedDataStorable?]()
        list["sequenceUuid"] = sequenceUuid
        list["uuid"] = uuid
        list["createdDate"] = createdDate
        list["modifiedDate"] = modifiedDate
        list["gameVersion"] = gameVersion.rawValue
        list["gender"] = gender == .Male ? "M" : "F"
        list["name"] = name.stringValue
        list["appearance"] = appearance.format()
        list["photo"] = photo.stringValue
        list["origin"] = origin.rawValue
        list["reputation"] = reputation.rawValue
        list["class"] = classTalent.rawValue
        return SerializedData(list)
    }
    
}
extension Shepard: SerializedDataRetrievable {
    
    public init(data: SerializedData) {
        self.init(sequenceUuid: "")
        setData(data)
    }
    
    public init(serializedData data: String) throws {
        self.init(data: try SerializedData(serializedData: data))
    }
    
    public mutating func setData(data: SerializedData) {
        setData(data, gameConversion: nil)
    }
    
    ///
    /// Creates a shepard with a dictionary of data. Can be from saved values, or from a previous game.
    /// Values general to all shepards within a set should be placed in setCommonData instead.
    ///
    public mutating func setData(data: SerializedData, gameConversion oldGame: GameSequence.GameVersion?) {
        //don't first any changes from these functions - they aren't true changes, just loading data from elsewhere
        let oldNotifyChanges = notifyChanges
        notifyChanges = false
        
        let gender = data["gender"]?.string == "M" ? Gender.Male : Gender.Female // just for local use
        
        if let oldGame = oldGame {
            var appearance = Appearance(data["appearance"]?.string ?? "", fromGame: oldGame, withGender: gender)
            appearance.convert(toGame: gameVersion)
            self.appearance = appearance
        } else {
            self.appearance = Appearance(data["appearance"]?.string ?? "", fromGame: gameVersion, withGender: gender)
        }
        
        classTalent = ClassTalent(rawValue: data["class"]?.string ?? "") ?? classTalent
        
        setCommonData(data)
        
        if oldGame == nil {
            sequenceUuid = data["sequenceUuid"]?.string ?? sequenceUuid
            uuid = data["uuid"]?.string ?? uuid
            gameVersion = GameSequence.GameVersion(rawValue: data["gameVersion"]?.string ?? "0") ?? .Game1
            createdDate = data["createdDate"]?.date ?? NSDate()
            modifiedDate = data["modifiedDate"]?.date ?? NSDate()
        }
        
        if let photo = Photo(data: data["photo"]) {
            self.photo = photo
        }
        
        notifyChanges = oldNotifyChanges
    }
    
    ///
    /// Data shared by all shepards in a Set.
    /// Put souvenirs/achievements here?
    ///
    public mutating func setCommonData(data: SerializedData) {
        let gender = data["gender"]?.string == "M" ? Gender.Male : Gender.Female
        
        setName(data["name"]?.string)
        
        origin = Origin(rawValue: data["origin"]?.string ?? "") ?? origin
        reputation = Reputation(rawValue: data["reputation"]?.string ?? "") ?? reputation
        
        // do gender last (it changes stuff):
        self.gender = gender
    }
}



