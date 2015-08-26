//
//  Shepard.Game.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/16/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

extension Shepard {

    public enum Game: String {
        case Game1 = "1", Game2 = "2", Game3 = "3"
        func list() -> [Game] {
            return [.Game1, .Game2, .Game3]
        }
    }
}

// already Equatable