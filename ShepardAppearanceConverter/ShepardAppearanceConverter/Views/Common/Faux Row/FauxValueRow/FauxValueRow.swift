//
//  FauxValueRow.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/14/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

@IBDesignable public class FauxValueRow: UIView {
    
    @IBInspectable public var title: String = "Label" {
        didSet {
            if oldValue != title {
                setupRow()
            }
        }
    }
    @IBInspectable public var value: String = "Label" {
        didSet {
            if oldValue != value {
                setupRow()
            }
        }
    }
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
    @IBInspectable public var hideArrow: Bool = false {
        didSet {
            if oldValue != hideArrow {
                setupRow()
            }
        }
    }
    @IBInspectable public var hideTitle: Bool = false {
        didSet {
            if oldValue != hideTitle {
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
    private var hideAutolayout = HideAutolayoutUtility()
    private var nib: FauxValueRowNib?
    
    public override func layoutSubviews() {
        if !didSetup {
            setupRow()
        }
        super.layoutSubviews()
    }
    
    internal func setupRow() {
        if nib == nil, let view = FauxValueRowNib.loadNib() {
            insertSubview(view, atIndex: 0)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.constraintAllEdgesEqualTo(self)
            nib = view
        }
        if let view = nib {
            view.titleLabel.text = "\(title):"
            if hideTitle {
                hideAutolayout.hide(view.titleLabel, key: "titleLabel")
            } else {
                hideAutolayout.show(view.titleLabel, key: "titleLabel")
            }
            view.valueLabel.text = value
            if hideArrow {
                hideAutolayout.hide(view.disclosureImageView, key: "disclosureImageView")
            } else {
                hideAutolayout.show(view.disclosureImageView, key: "disclosureImageView")
            }
            view.fauxContentRow.highlight = highlight
            view.fauxContentRow.isFirst = isFirst
            view.fauxContentRow.isLast = isLast
            view.fauxContentRow.onClick = onClick != nil ? { self.clickRow() } : nil
            didSetup = true
        }
    }
    
    public func clickRow() {
        onClick?()
    }
}

@IBDesignable public class FauxValueRowNib: UIView {

    @IBOutlet public weak var fauxContentRow: FauxContentRow!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var valueLabel: UILabel!
    @IBOutlet public weak var disclosureImageView: UIImageView!
    
    public class func loadNib() -> FauxValueRowNib? {
        let bundle = NSBundle(forClass: FauxValueRowNib.self)
        if let view = bundle.loadNibNamed("FauxValueRowNib", owner: self, options: nil)?.first as? FauxValueRowNib {
            return view
        }
        return nil
    }
}
 