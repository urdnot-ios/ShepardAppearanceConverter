//
//  Shepard.Name.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/16/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

extension Shepard {

    public enum Name {
        case DefaultMaleName
        case DefaultFemaleName
        case Custom(name: String)
        var stringValue: String? {
            let defaultMaleName = "John"
            let defaultFemaleName = "Jane"
            switch self {
            case .DefaultMaleName:
                return defaultMaleName
            case .DefaultFemaleName:
                return defaultFemaleName
            case .Custom(let name):
                return name
            }
        }
    }
}

extension Shepard.Name: Equatable {}

public func ==(a: Shepard.Name, b: Shepard.Name) -> Bool {
    return a.stringValue == b.stringValue
//    switch (a, b) {
//    case (.DefaultMaleName, .DefaultMaleName): return true
//    case (.DefaultFemaleName, .DefaultFemaleName): return true
//    case (.Custom(let a), .Custom(let b)) where a == b: return true
//    case (.Custom(let a), .Custom(let b)) where a == b: return true
//    default: return false
//    }
}