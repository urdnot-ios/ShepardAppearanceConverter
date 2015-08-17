//
//  UIViewController.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/15/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

extension UIViewController {
    internal var isInterfaceBuilder: Bool {
        #if TARGET_INTERFACE_BUILDER
            return true
        #else
            return false
        #endif
    }
}