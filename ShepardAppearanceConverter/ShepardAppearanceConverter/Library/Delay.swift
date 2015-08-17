//
//  Delay.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/16/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

public struct Delay {
    public static func bySeconds(seconds: Double, _ block: (()->Void)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), block)
    }
}