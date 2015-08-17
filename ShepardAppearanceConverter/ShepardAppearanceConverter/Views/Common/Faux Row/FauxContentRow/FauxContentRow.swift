//
//  FauxContentRow.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/9/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

@IBDesignable public class FauxContentRow: UIView {
    
    @IBInspectable public var isFirst: Bool = false {
        didSet {
            if oldValue != isFirst {
                setupRow()
            }
        }
    }
    @IBInspectable public var isLast: Bool = false {
        didSet {
            if oldValue != isLast {
                setupRow()
            }
        }
    }
    @IBInspectable public var highlight: UIColor = Styles.RowHighlightColor {
        didSet {
            if oldValue != highlight {
                setupRow()
            }
        }
    }
    
    public var onClick: (()->Void)? {
        didSet {
            setupRow()
        }
    }
    
    internal var didSetup = false
    private var nib: FauxContentRowNib?
    private var button: FauxRowButton?
    
    public override func layoutSubviews() {
        if !didSetup {
            setupRow()
        }
        super.layoutSubviews()
    }
    
    internal func setupRow() {
        if nib == nil, let view = FauxContentRowNib.loadNib() {
            insertSubview(view, atIndex: 0)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.constraintAllEdgesEqualTo(self)
            nib = view
            button = FauxRowButton()
            self.addSubview(button!)
            button?.translatesAutoresizingMaskIntoConstraints = false
            button?.constraintAllEdgesEqualTo(self)
            button?.addTarget(self, action: Selector("clickRow"), forControlEvents: UIControlEvents.TouchUpInside)

        }
        if let view = nib {
            view.rowWrapperView.top = isFirst
            view.rowWrapperView.bottom = isLast
            view.rowDividerView.hidden = isLast
            button?.hidden = (onClick == nil)
            button?.highlightedColor = highlight
            didSetup = true
        }
    }
    

    internal class FauxRowButton: UIButton {
        var highlightedColor = UIColor.clearColor()
        override var highlighted: Bool {
            didSet {
                if highlighted {
                    alpha = 0.2
                    backgroundColor = highlightedColor
                }
                else {
                    backgroundColor = UIColor.clearColor()
                }
            }
        }
    }
    
    public func clickRow() {
        onClick?()
    }
}

@IBDesignable public class FauxContentRowNib: UIView {

    @IBOutlet public weak var rowWrapperView: HairlineBorderView!
    @IBOutlet public weak var rowDividerView: HairlineBorderView!
    
    public class func loadNib() -> FauxContentRowNib? {
        let bundle = NSBundle(forClass: FauxContentRowNib.self)
        if let view = bundle.loadNibNamed("FauxContentRowNib", owner: self, options: nil)?.first as? FauxContentRowNib {
            return view
        }
        return nil
    }
}
 