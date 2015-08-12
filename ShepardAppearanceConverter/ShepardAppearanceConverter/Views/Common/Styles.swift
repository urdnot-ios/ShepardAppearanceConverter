//
//  Styles.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/11/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

struct Styles {
    static func applyGlobalStyles() {
        let bundle = NSBundle(forClass: ShepardController.self)
        let minimumTrackImage = UIImage(named: "Slider Fill", inBundle: bundle, compatibleWithTraitCollection: nil)
        let maximumTrackImage = UIImage(named: "Slider Track", inBundle: bundle, compatibleWithTraitCollection: nil)
        UISlider.appearance().setMinimumTrackImage(minimumTrackImage, forState: .Normal)
        UISlider.appearance().setMaximumTrackImage(maximumTrackImage, forState: .Normal)
        UISlider.appearance().setThumbImage(UIImage(), forState: .Normal)
        UISlider.appearance().setThumbImage(UIImage(), forState: .Highlighted)
    }
}