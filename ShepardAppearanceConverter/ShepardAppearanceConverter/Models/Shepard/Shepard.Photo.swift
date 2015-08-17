//
//  Shepard.Photo.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/16/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

extension Shepard {

    public enum Photo: Equatable {
        case DefaultMalePhoto
        case DefaultFemalePhoto
        case Custom(file: String)
        var stringValue: String {
            switch self {
            case .DefaultMalePhoto:
                return "BroShep Sample"
            case .DefaultFemalePhoto:
                return "FemShep Sample"
            case .Custom(let fileName):
                return "Custom:\(fileName)"
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
                if let photo = SavedData.loadImageFromDocuments(fileName) {
                    return photo
                }
            }
            return nil
        }
    }
}

public func ==(a: Shepard.Photo, b: Shepard.Photo) -> Bool {
    switch (a, b) {
    case (.DefaultMalePhoto, .DefaultMalePhoto): return true
    case (.DefaultFemalePhoto, .DefaultFemalePhoto): return true
    case (.Custom(let a), .Custom(let b)) where a == b: return true
    default: return false
    }
}