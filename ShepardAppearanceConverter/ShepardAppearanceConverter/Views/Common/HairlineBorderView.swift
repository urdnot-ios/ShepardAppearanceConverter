//
//  HairlineBorderView.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/9/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

@IBDesignable
public class HairlineBorderView: UIView {
    @IBInspectable public var color: UIColor = UIColor.clearColor()
    @IBInspectable public var top: Bool = true
    @IBInspectable public var bottom: Bool = true
    @IBInspectable public var left: Bool = true
    @IBInspectable public var right: Bool = true
    
    var borderLayer: CAShapeLayer?

    public override func layoutSubviews() {
        super.layoutSubviews()
        drawBorders()
    }
    
    func drawBorders() {
        let hairline = CGFloat(1.0) / UIScreen.mainScreen().scale
        if borderLayer == nil {
            borderLayer = CAShapeLayer()
            borderLayer?.lineWidth = hairline
            borderLayer?.strokeColor = color.CGColor
            borderLayer?.fillColor = UIColor.clearColor().CGColor
            layer.addSublayer(borderLayer!)
        }
        let path = UIBezierPath()
        let hairlinePosition = hairline / CGFloat(2.0)
        if top == true {
            path.moveToPoint(CGPointMake(0, 0 - hairlinePosition))
            path.addLineToPoint(CGPointMake(frame.size.width, 0 - hairlinePosition))
        }
        if bottom == true {
            path.moveToPoint(CGPointMake(0, frame.size.height + hairlinePosition))
            path.addLineToPoint(CGPointMake(frame.size.width, frame.size.height + hairlinePosition))
        }
        if left == true {
            path.moveToPoint(CGPointMake(0 - hairlinePosition, 0))
            path.addLineToPoint(CGPointMake(0 - hairlinePosition, frame.size.height))
        }
        if right == true {
            path.moveToPoint(CGPointMake(frame.size.width + hairlinePosition, 0))
            path.addLineToPoint(CGPointMake(frame.size.width + hairlinePosition, frame.size.height))
        }
        borderLayer?.frame = bounds
        borderLayer?.path = path.CGPath
        borderLayer?.zPosition = CGFloat(layer.sublayers?.count ?? 0)
    }
}