//
//  Styles.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/11/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

public struct Styles {
    public struct Colors {
    public static let NormalColor = UIColor.blackColor()
    public static let TintColor = UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)
    public static let AccentColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public static let AltAccentColor = UIColor(red: 0.2, green: 0.3, blue: 0.9, alpha: 1.0)
    public static let BorderColor = UIColor.blackColor()
    public static let BackgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    public static let OverlayColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.8)
    public static let RowHighlightColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
    }
    
    public static var fontsList: [IBFontStyle: String] = [
        .Normal: "Avenir-Regular",
        .Italic: "Avenir-Italic",
        .Medium: "Avenir-Medium",
        .SemiBold: "Avenir-SemiBold",
        .Bold: "Avenir-Bold",
    ]
    
    public static var stylesList: [String: IBStyleProperties] = [
        "NormalColorText.17": [
                    .Font: IBFont.SizeStyle(17,.Normal),
                    .TextColor: Colors.NormalColor,
                ],
        "TintColorText.17": [
                    .Font: IBFont.SizeStyle(17,.Normal),
                    .TextColor: Colors.TintColor,
                ],
        "AccentColorText.17": [
                    .Font: IBFont.SizeStyle(17,.Normal),
                    .TextColor: Colors.AccentColor,
                ],
        "AltAccentColorText.14": [
                    .Font: IBFont.SizeStyle(14,.Normal),
                    .TextColor: Colors.AltAccentColor,
                ],
    ]
    
    public static func applyGlobalStyles(window: UIWindow?) {
        IBStyles.fontsList = fontsList
        IBStyles.stylesList = stylesList
        
        window?.tintColor = Styles.Colors.TintColor
        UISegmentedControl.appearance().tintColor = Styles.Colors.TintColor
        UISegmentedControl.appearance().backgroundColor = Styles.Colors.AccentColor
        UISwitch.appearance().onTintColor = Styles.Colors.TintColor
        UISwitch.appearance().tintColor = Styles.Colors.AccentColor
        
//        let fontNormal = UIFont.systemFontOfSize(17.0)
//        UISegmentedControl.appearance().setTitleTextAttributes([NSFontAttributeName: fontNormal], forState: .Normal)
    
        let bundle = NSBundle(forClass: ShepardController.self)
        let minimumTrackImage = UIImage(named: "Slider Fill", inBundle: bundle, compatibleWithTraitCollection: nil)
        let maximumTrackImage = UIImage(named: "Slider Track", inBundle: bundle, compatibleWithTraitCollection: nil)
        UISlider.appearance().setMinimumTrackImage(minimumTrackImage, forState: .Normal)
        UISlider.appearance().setMaximumTrackImage(maximumTrackImage, forState: .Normal)
        UISlider.appearance().setThumbImage(UIImage(), forState: .Normal)
        UISlider.appearance().setThumbImage(UIImage(), forState: .Highlighted)
    }
}