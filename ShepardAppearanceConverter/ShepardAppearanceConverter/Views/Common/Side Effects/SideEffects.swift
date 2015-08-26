//
//  FauxRow.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/9/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

@IBDesignable public class SideEffects: UIView {
    
    public var multipleTexts: [String] = [] {
        didSet {
            if oldValue != multipleTexts {
                setupRow()
            }
        }
    }
    
    @IBInspectable public var text: String = "Label" {
        // I will parse out links later as markup [name|action] ?
        // TODO: Parse out newlines to allow multiple values in IB?
        didSet {
            if oldValue != text {
                setupRow()
            }
        }
    }
    
    internal var didSetup = false
    private var nib: SideEffectsNib?
    
    public override func layoutSubviews() {
        if !didSetup {
            setupRow()
        }
        super.layoutSubviews()
    }
    
    internal func setupRow() {
        if nib == nil, let view = SideEffectsNib.loadNib() {
            insertSubview(view, atIndex: 0)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.constraintAllEdgesEqualTo(self)
            nib = view
        }
        if let view = nib {
            hidden = ((text == "Label" || text.isEmpty) && multipleTexts.isEmpty)
            if !hidden {
                if multipleTexts.isEmpty {
                    if text.rangeOfString("\u{2028}\u{2028}") != nil {
                        multipleTexts = text.componentsSeparatedByString("\u{2028}\u{2028}").map{ String($0) }
                    } else if text.rangeOfString("\n\n") != nil {
                        multipleTexts = text.componentsSeparatedByString("\n\n").map{ String($0) }
                    } else {
                        multipleTexts = [text]
                    }
                    return
                }
                view.setEntries(multipleTexts)
            }
            didSetup = true
        }
    }
}

@IBDesignable public class SideEffectsNib: UIView {
    
    @IBOutlet weak var entriesStack: UIStackView!
    @IBOutlet weak var entryWrapperView: UIView!
    
    public func setEntries(entries: [String]) {
        for i in 0..<entries.count {
            if i > (entriesStack?.arrangedSubviews.count ?? 0) - 1 {
                if let entryWrapperView = self.entryWrapperView?.clone() {
                    entriesStack?.addArrangedSubview(entryWrapperView)
                }
                else {
                    break
                }
            }
            if let entryWrapperView = entriesStack?.arrangedSubviews[i] {
                for view in entryWrapperView.subviews ?? [] where view is UILabel {
                    (view as? UILabel)?.text = entries[i]
                }
            }
        }
    }
    
    public class func loadNib() -> SideEffectsNib? {
        let bundle = NSBundle(forClass: SideEffectsNib.self)
        if let view = bundle.loadNibNamed("SideEffectsNib", owner: self, options: nil)?.first as? SideEffectsNib {
            return view
        }
        return nil
    }
}
 