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
                hasSequenceChanges = true //?
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
        let fileName = "MyShepardPhoto\(uuid)"
        if image.save(documentsFileName: fileName) {
            photo = .Custom(file: fileName)
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

    public func getData(target target: SerializedDataOrigin = .LocalStore) -> SerializedData {
        var list = [String: SerializedDataStorable?]()
        list["sequence_uuid"] = sequenceUuid
        list["uuid"] = uuid
        list["created_date"] = createdDate
        list["modified_date"] = modifiedDate
        list["game_version"] = gameVersion.rawValue
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
    
    public init(data: SerializedData, origin: SerializedDataOrigin = .LocalStore) {
        self.init(sequenceUuid: "")
        setData(data, origin: origin)
    }
    
    public init(serializedData data: String, origin: SerializedDataOrigin = .LocalStore) throws {
        self.init(data: try SerializedData(serializedData: data), origin: origin)
    }
    
    public mutating func setData(data: SerializedData, origin: SerializedDataOrigin = .LocalStore) {
        setData(data, gameConversion: nil, origin: origin)
    }
    
    ///
    /// Creates a shepard with a dictionary of data. Can be from saved values, or from a previous game.
    /// Values general to all shepards within a set should be placed in setCommonData instead.
    ///
    public mutating func setData(data: SerializedData, gameConversion oldGame: GameSequence.GameVersion?, origin: SerializedDataOrigin = .LocalStore) {
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
            self.sequenceUuid = data["sequence_uuid"]?.string ?? sequenceUuid
            self.uuid = data["uuid"]?.string ?? uuid
            self.gameVersion = GameSequence.GameVersion(rawValue: data["game_version"]?.string ?? "0") ?? .Game1
            self.createdDate = data["created_date"]?.date ?? NSDate()
            self.modifiedDate = data["modified_date"]?.date ?? NSDate()
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



