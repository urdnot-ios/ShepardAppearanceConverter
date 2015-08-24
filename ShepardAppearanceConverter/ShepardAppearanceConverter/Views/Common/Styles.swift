//
//  Styles.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/11/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

extension Styles {
    public struct Colors {
    public static let NormalColor = UIColor.blackColor()
    public static let TintColor = UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)
    public static let TintOppositeColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public static let AccentColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    public static let AltAccentColor = UIColor(red: 0.2, green: 0.3, blue: 0.9, alpha: 1.0)
    public static let NavBarTitle = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    public static let BorderColor = UIColor.blackColor()
    public static let BackgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    public static let OverlayColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.8)
    public static let RowHighlightColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
    }
    
    public static var fontsList: [IBFontStyle: String] {
        return [
        .Normal: "Avenir-Regular",
        .Italic: "Avenir-Italic",
        .Medium: "Avenir-Medium",
        .SemiBold: "Avenir-Heavy",
        .Bold: "Avenir-Black",
        ]
    }
    
    public static var stylesList: [String: IBStyleProperties] {
        return [
        "NormalColorText.13": [
                    .Font: IBFont.SizeStyle(13,.Normal),
                    .TextColor: Colors.NormalColor,
                ],
        "NormalColorText.13.Italic": [
                    .Font: IBFont.SizeStyle(13,.Italic),
                    .TextColor: Colors.NormalColor,
                ],
        "NormalColorText.15": [
                    .Font: IBFont.SizeStyle(17,.Normal),
                    .TextColor: Colors.NormalColor,
                ],
        "NormalColorText.15.Medium": [
                    .Font: IBFont.SizeStyle(17,.Medium),
                    .TextColor: Colors.NormalColor,
                ],
        "NormalColorText.17": [
                    .Font: IBFont.SizeStyle(17,.Normal),
                    .TextColor: Colors.NormalColor,
                ],
        "NormalColorText.17.Medium": [
                    .Font: IBFont.SizeStyle(17,.Medium),
                    .TextColor: Colors.NormalColor,
                ],
        "NormalColorText.20.Medium": [
                    .Font: IBFont.SizeStyle(20,.Medium),
                    .TextColor: Colors.NormalColor,
                ],
        "TintColorText.13.Medium": [
                    .Font: IBFont.SizeStyle(13,.Medium),
                    .TextColor: Colors.TintColor,
                ],
        "TintColorText.17": [
                    .Font: IBFont.SizeStyle(17,.Normal),
                    .TextColor: Colors.TintColor,
                ],
        "AccentColorText.13": [
                    .Font: IBFont.SizeStyle(13,.Normal),
                    .TextColor: Colors.AccentColor,
                ],
        "AccentColorText.13.Italic": [
                    .Font: IBFont.SizeStyle(13,.Italic),
                    .TextColor: Colors.AccentColor,
                ],
        "AccentColorText.17": [
                    .Font: IBFont.SizeStyle(17,.Normal),
                    .TextColor: Colors.AccentColor,
                ],
        "AltAccentColorText.13": [
                    .Font: IBFont.SizeStyle(13,.Normal),
                    .TextColor: Colors.AltAccentColor,
                ],
        ]
    }
    
    public static func applyGlobalStyles(window: UIWindow?) {
        IBStyles.fontsList = fontsList
        IBStyles.stylesList = stylesList
        
        window?.tintColor = Styles.Colors.TintColor
        
        if let titleFont = IBFont.SizeStyle(18,.SemiBold).getUIFont() {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: titleFont, NSForegroundColorAttributeName: Colors.NavBarTitle]
        }
        if let titleFont = IBFont.SizeStyle(17,.Normal).getUIFont() {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: titleFont], forState: .Normal)
        }
        
        UISegmentedControl.appearance().tintColor = Styles.Colors.TintColor
        UISegmentedControl.appearance().backgroundColor = Styles.Colors.TintOppositeColor
        UISwitch.appearance().onTintColor = Styles.Colors.TintColor
        UISwitch.appearance().tintColor = Styles.Colors.TintOppositeColor
        
//        let fontNormal = UIFont.systemFontOfSize(17.0)
//        UISegmentedControl.appearance().setTitleTextAttributes([NSFontAttributeName: fontNormal], forState: .Normal)
    
        let bundle = NSBundle.currentAppBundle
        let minimumTrackImage = UIImage(named: "Slider Fill", inBundle: bundle, compatibleWithTraitCollection: nil)?.stretchableImageWithLeftCapWidth(10, topCapHeight: 0)
        let maximumTrackImage = UIImage(named: "Slider Track", inBundle: bundle, compatibleWithTraitCollection: nil)?.stretchableImageWithLeftCapWidth(10, topCapHeight: 0)
        let thumbImage = UIImage(named: "Slider Thumb", inBundle: bundle, compatibleWithTraitCollection: nil)
        UISlider.appearance().setMinimumTrackImage(minimumTrackImage, forState: .Normal)
        UISlider.appearance().setMaximumTrackImage(maximumTrackImage, forState: .Normal)
        UISlider.appearance().setThumbImage(thumbImage, forState: .Normal)
        UISlider.appearance().setThumbImage(thumbImage, forState: .Highlighted)
    }
}