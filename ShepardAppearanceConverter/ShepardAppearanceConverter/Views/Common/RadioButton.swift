//
//  RadioButton.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/16/2015.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

@IBDesignable public class RadioButton: UIButton {
    @IBInspectable var on: Bool = false { didSet{ toggle(on) } }
    
    private static let uncheckedImage = UIImage(named: "Radio Empty", inBundle: NSBundle(forClass: RadioButton.self), compatibleWithTraitCollection: nil)
    private static let checkedImage = UIImage(named: "Radio Filled", inBundle: NSBundle(forClass: RadioButton.self), compatibleWithTraitCollection: nil)
    
    private func toggle(on: Bool){
        if on {
            setBackgroundImage(RadioButton.checkedImage, forState: .Normal)
        } else {
            setBackgroundImage(RadioButton.uncheckedImage, forState: .Normal)
        }
    }
    
    internal var didSetup = false
    
    public override func layoutSubviews() {
        if !didSetup {
            toggle(on)
            didSetup = true
        }
        super.layoutSubviews()
    }
}