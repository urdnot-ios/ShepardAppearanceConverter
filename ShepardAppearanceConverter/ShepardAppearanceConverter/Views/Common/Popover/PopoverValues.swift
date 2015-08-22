//
//  PopoverValues.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/19/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

public struct PopoverValues {
    public static let PreferredDefaultSize = CGSize(width: 400, height: 400)
    public static let PopoverPadding = CGFloat(20)
    public static let MagicNumberCorrectPopoverRight = CGFloat(25) // using sourceView WITH sourceRect causes too much padding on right side :/
    public static let OverlayColor = Styles.Colors.OverlayColor
    public static let DefaultBackgroundColor = Styles.Colors.BackgroundColor
    public static let BorderColor = Styles.Colors.BorderColor
    public static let BorderWidth = CGFloat(2)
}