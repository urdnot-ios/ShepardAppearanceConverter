//
//  NSBundle.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/11/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation


extension NSBundle {
    class var currentAppBundle: NSBundle {
        return NSBundle(forClass: ShepardFlowController.self) ?? NSBundle.mainBundle()
    }
}