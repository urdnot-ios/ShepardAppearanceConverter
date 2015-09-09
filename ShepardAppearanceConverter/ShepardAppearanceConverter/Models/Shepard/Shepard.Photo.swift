//
//  Shepard.Photo.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/16/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

extension Shepard {

    public enum Photo {
        case DefaultMalePhoto
        case DefaultFemalePhoto
        case Custom(fileName: String)
        var stringValue: String {
            switch self {
            case .DefaultMalePhoto:
                return "BroShep Sample"
            case .DefaultFemalePhoto:
                return "FemShep Sample"
            case .Custom(let fileName):
                return "\(fileName)"
            }
        }
        func image() -> UIImage? {
            switch self {
            case .DefaultMalePhoto:
                if let photo = UIImage(named: self.stringValue, inBundle: NSBundle.currentAppBundle, compatibleWithTraitCollection: nil) {
                    return photo
                }
            case .DefaultFemalePhoto:
                if let photo = UIImage(named: self.stringValue, inBundle: NSBundle.currentAppBundle, compatibleWithTraitCollection: nil) {
                    return photo
                }
            case .Custom(let fileName):
                if let photo = UIImage(documentsFileName: fileName) {
                    return photo
                }
            }
            return nil
        }
        public static func create(image: UIImage, forShepard shepard: Shepard) -> Photo? {
            let fileName = "MyShepardPhoto\(shepard.uuid)"
            if image.save(documentsFileName: fileName) {
                return Photo.Custom(fileName: fileName)
            } else {
                return nil
            }
        }
    }
}

extension Shepard.Photo: Equatable {}

public func ==(a: Shepard.Photo, b: Shepard.Photo) -> Bool {
    switch (a, b) {
    case (.DefaultMalePhoto, .DefaultMalePhoto): return true
    case (.DefaultFemalePhoto, .DefaultFemalePhoto): return true
    case (.Custom(let a), .Custom(let b)) where a == b: return true
    default: return false
    }
}


//MARK: Save/Retrieve Data

extension Shepard.Photo {
    
    /// special retriever for saved image
    public init?(data: SerializedData?) {
        if let fileName = data?.string {
            if fileName == Shepard.Photo.DefaultMalePhoto.stringValue {
                self = .DefaultMalePhoto
            } else if fileName == Shepard.Photo.DefaultFemalePhoto.stringValue {
                self = .DefaultFemalePhoto
            } else {
                self = Shepard.Photo.Custom(fileName: fileName)
            }
            return
        }
        return nil
    }
    
}


    