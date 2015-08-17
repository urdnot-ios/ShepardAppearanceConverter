//
//  FauxRow.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/9/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

@IBDesignable public class FauxRadioRow: UIView {
    
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
    @IBInspectable public var isOn: Bool = false {
        didSet {
            if oldValue != isOn {
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
    private var nib: FauxRadioRowNib?
    
    public override func layoutSubviews() {
        if !didSetup {
            setupRow()
        }
        super.layoutSubviews()
    }
    
    internal func setupRow() {
        if nib == nil, let view = FauxRadioRowNib.loadNib() {
            insertSubview(view, atIndex: 0)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.constraintAllEdgesEqualTo(self)
            nib = view
        }
        if let view = nib {
            view.titleLabel.text = title
            view.radioButton.on = isOn
            view.fauxContentRow.highlight = highlight
            view.fauxContentRow.isFirst = isFirst
            view.fauxContentRow.isLast = isLast
            view.fauxContentRow.onClick = { self.clickRow() }
            didSetup = true
        }
    }
    
    public func clickRow() {
        isOn = !isOn
        nib?.radioButton.on = isOn
        onClick?()
    }
}

@IBDesignable public class FauxRadioRowNib: UIView {

    @IBOutlet weak var fauxContentRow: FauxContentRow!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var radioButton: RadioButton!
    
    public class func loadNib() -> FauxRadioRowNib? {
        let bundle = NSBundle(forClass: FauxRadioRowNib.self)
        if let view = bundle.loadNibNamed("FauxRadioRowNib", owner: self, options: nil)?.first as? FauxRadioRowNib {
            return view
        }
        return nil
    }
}
 