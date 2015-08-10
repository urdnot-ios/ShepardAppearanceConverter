//
//  CurrentGame.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/9/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

class CurrentGame {
    static var shepard = Shepard() {
        didSet {
            print("X")
        }
    }
    static var string = ""
}