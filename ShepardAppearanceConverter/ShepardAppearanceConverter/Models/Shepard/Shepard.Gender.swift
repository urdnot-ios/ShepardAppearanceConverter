//
//  Shepard.Gender.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/16/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

extension Shepard {

    public enum Gender {
        case Male, Female
        static func list() -> [Gender] {
            return [.Male, .Female]
        }
    }
    
}
