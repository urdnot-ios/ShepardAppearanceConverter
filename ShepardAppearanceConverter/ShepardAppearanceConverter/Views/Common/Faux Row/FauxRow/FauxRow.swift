//
//  FauxRow.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/9/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

@IBDesignable public class FauxRow: UIView {
    
    @IBInspectable public var title: String = "Label" {
        didSet {
            if oldValue != title {
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
    private var nib: FauxRowNib?
    
    public override func layoutSubviews() {
        if !didSetup {
            setupRow()
        }
        super.layoutSubviews()
    }
    
    internal func setupRow() {
        if nib == nil, let view = FauxRowNib.loadNib() {
            insertSubview(view, atIndex: 0)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.constraintAllEdgesEqualTo(self)
            nib = view
        }
        if let view = nib {
            view.titleLabel.text = title
            if hideArrow {
                hideAutolayout.hide(view.disclosureImageView, key: "disclosureImageView")
            } else {
                hideAutolayout.show(view.disclosureImageView, key: "disclosureImageView")
            }
            view.fauxContentRow.highlight = highlight
            view.fauxContentRow.isFirst = isFirst
            view.fauxContentRow.isLast = isLast
            view.fauxContentRow.onClick = { self.onClick?() }
            didSetup = true
        }
    }
    
    public func clickRow() {
        onClick?()
    }
}

@IBDesignable public class FauxRowNib: UIView {

    @IBOutlet weak var fauxContentRow: FauxContentRow!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var disclosureImageView: UIImageView!
    
    public class func loadNib() -> FauxRowNib? {
        let bundle = NSBundle(forClass: FauxRowNib.self)
        if let view = bundle.loadNibNamed("FauxRowNib", owner: self, options: nil)?.first as? FauxRowNib {
            return view
        }
        return nil
    }
}
 