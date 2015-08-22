//
//  PopoverBackgroundView.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/18/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

class PopoverBackgroundView : UIPopoverBackgroundView {
    static var CustomBackgroundColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawOverlay()
        drawPopoverBackground()
        drawPopoverShadow()
    }
    
    var overlay: CAShapeLayer?
    
    func drawOverlay() {
        clipsToBounds = false
        if overlay == nil {
            overlay = CAShapeLayer()
            overlay?.frame = CGRectMake( -10000, -10000, 20000, 20000)
            overlay?.backgroundColor = PopoverValues.OverlayColor.CGColor
            layer.insertSublayer(overlay!, atIndex: 0)
        }
    }
    
    var backgroundLayers: [CAShapeLayer] = []
    
    func drawPopoverBackground() {
        let colors: [UIColor] = [PopoverValues.BorderColor, PopoverBackgroundView.CustomBackgroundColor ?? PopoverValues.DefaultBackgroundColor]
        let offset: [CGFloat] = [0.0, PopoverValues.BorderWidth]
        assert(colors.count == offset.count)
        for index in 0..<colors.count {
            if index >= backgroundLayers.count {
                let backgroundLayer = CAShapeLayer()
                layer.addSublayer(backgroundLayer)
                backgroundLayers.append(backgroundLayer)
                backgroundLayer.backgroundColor = colors[index].CGColor
            }
            backgroundLayers[index].frame = CGRectMake(offset[index], offset[index], bounds.width - (2 * offset[index]), bounds.height - (2 * offset[index]))
        }
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsetsMake(PopoverValues.BorderWidth, PopoverValues.BorderWidth, PopoverValues.BorderWidth, PopoverValues.BorderWidth)
    }
    
    var shadow: CAShapeLayer?
    
    func removeDefaultShadow() {
        layer.shadowOpacity = 0
        layer.shadowColor = UIColor.clearColor().CGColor // (mostly) removes iOS ugly shadow that refuses to be customized
    }
    
    func drawPopoverShadow() {
        // a nice, narrow, subtle shadow
        if shadow == nil {
            removeDefaultShadow()
            shadow = CAShapeLayer()
            layer.insertSublayer(shadow!, atIndex: 1)
            shadow?.shadowOffset = CGSizeZero
            shadow?.shadowRadius = 10.0
            shadow?.shadowColor = UIColor.blackColor().CGColor
            shadow?.shadowOpacity = 0.2
        }
        let shadowWidth = CGFloat(5.0)
        let shadowFrame = CGRectMake(-1 * shadowWidth, -1 * shadowWidth, bounds.width + (shadowWidth * 2), bounds.height + (shadowWidth * 2))
        shadow?.shadowPath = UIBezierPath(rect: shadowFrame).CGPath
    }

    // other required stuff:
    
    override var arrowOffset: CGFloat {
        get { return 0.0 }
        set {}
    }
    
    override var arrowDirection : UIPopoverArrowDirection {
        get { return UIPopoverArrowDirection.Unknown }
        set {}
    }
    
    override class func arrowBase() -> CGFloat {
        return 0.0
    }

    override class func arrowHeight() -> CGFloat {
        return 0.0
    }

    override class func wantsDefaultContentAppearance() -> Bool {
        return false
    }
}