//
//  Dictionary.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/11/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

// from: http://stackoverflow.com/a/24219069
extension Dictionary {
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
}