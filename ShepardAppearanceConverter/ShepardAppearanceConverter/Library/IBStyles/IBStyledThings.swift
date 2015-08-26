//
//  IBStyledThings.swift
//
//  Created by Emily Ivie on 2/25/15.
//

import UIKit

@IBDesignable
public class IBStyledView: UIView, IBStylable {
    @IBInspectable public var identifier: String! {
        didSet{ styler.applyStyles() }
    }
    var defaultIdentifier: String { return "View" }
    internal lazy var styler: IBStyler = { return IBStyler(delegate: self) }()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        styler.applyStyles()
    }
}

@IBDesignable
public class IBStyledLabel: UILabel, IBStylable {
    @IBInspectable public var identifier: String!{
        didSet{ styler.applyStyles() }
    }
    var defaultIdentifier: String { return "Label" }
    internal lazy var styler: IBStyler = { return IBStyler(delegate: self) }()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        styler.applyStyles()
    }
}

@IBDesignable
public class IBStyledTextField: UITextField, IBStylable {
    @IBInspectable public var identifier: String!{
        didSet{ styler.applyStyles() }
    }
    var defaultIdentifier: String { return "TextField" }
    internal lazy var styler: IBStyler = { return IBStyler(delegate: self) }()

    override public func layoutSubviews() {
        super.layoutSubviews()
        styler.applyStyles()
    }
}

@IBDesignable
public class IBStyledTextView: UITextView, IBStylable {
    @IBInspectable public var identifier: String!{
        didSet{ styler.applyStyles() }
    }
    var defaultIdentifier: String { return "TextView" }
    internal lazy var styler: IBStyler = { return IBStyler(delegate: self) }()

    override public func layoutSubviews() {
        super.layoutSubviews()
        styler.applyStyles()
    }
}

@IBDesignable
public class IBStyledImageView: UIImageView, IBStylable {
    @IBInspectable public var identifier: String!{
        didSet{ styler.applyStyles() }
    }
    var defaultIdentifier: String { return "ImageView" }
    internal lazy var styler: IBStyler = { return IBStyler(delegate: self) }()

    override public func layoutSubviews() {
        super.layoutSubviews()
        styler.applyStyles()
    }
}

@IBDesignable
public class IBStyledButton: UIButton, IBStylable {
    @IBInspectable public var identifier: String!{
        didSet{ styler.applyStyles() }
    }
    var defaultIdentifier: String { return "Button" }
    @IBInspectable public var previewDisabled: Bool = false
    @IBInspectable public var previewPressed: Bool = false
    internal lazy var styler: IBStyler = { return IBStyler(delegate: self) }()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if !isInterfaceBuilder {
            styler.applyStyles()
            var startState: UIControlState = enabled ? .Normal : .Disabled
            if highlighted {
                startState = .Highlighted
            }
            if selected {
                startState = .Selected
            }
            styler.applyState(startState)
        }
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        if previewDisabled {
            self.enabled = false
        } else if previewPressed {
            self.highlighted = true
        } else {
            styler.applyState(.Normal)
        }
    }
    
    //button-specific:
    override public var enabled: Bool {
        didSet {
            styler.applyState(self.state)
        }
    }
    override public var selected: Bool {
        didSet {
            styler.applyState(self.state)
        }
    }
    override public var highlighted: Bool {
        didSet {
            styler.applyState(self.state)
        }
    }
}

@IBDesignable
public class IBStyledSegmentedControl: UISegmentedControl, IBStylable {
    @IBInspectable public var identifier: String! {
        didSet{ styler.applyStyles() }
    }
    var defaultIdentifier: String { return "SegmentedControl" }
    internal lazy var styler: IBStyler = { return IBStyler(delegate: self) }()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        styler.applyStyles()
    }
}