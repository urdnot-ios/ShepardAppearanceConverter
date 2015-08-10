//
//  SectionHeader.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/9/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

public class SectionHeader: UIView {

    @IBOutlet weak var leadingMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    public var title: String? {
        didSet {
            setupPage()
        }
    }
    
    internal func setupPage() {
        titleLabel?.text = title ?? ""
    }
    
    public class func loadNib() -> SectionHeader? {
        let bundle = NSBundle(forClass: object_getClass(self)) //can't use dynamicType
        if let view = bundle.loadNibNamed("SectionHeader", owner: self, options: nil)?.first as? SectionHeader {
            return view
        }
        return nil
    }

}
 