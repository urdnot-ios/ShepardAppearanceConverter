//
//  PopoverTargetHandler.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/19/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

/// Example of code needed to implement this protocol:
///
///    lazy var popoverTargetHandler: PopoverTargetHandler = {
///        return PopoverTargetHandler(owner: self, targetView: self.someWiredUpView)
///    }()
///
///    override func viewWillAppear(animated: Bool) {
///        super.viewWillAppear(animated)
///        popoverTargetHandler.setupPopover()
///    }
///
///    override func viewDidLayoutSubviews() {
///        super.viewDidLayoutSubviews()
///        popoverTargetHandler.layoutPopover()
///    }
///
// Someday protocol extensions will allow me to tamper with viewDidLoad() and then this would be a great protocol.
// But that day is not here.
public class PopoverTargetHandler {
    unowned var owner: UIViewController
    var targetView: UIView!
    var lastTargetBounds: CGRect?
    var lastScreenBounds: CGRect?
    
    public init(owner: UIViewController, targetView: UIView!) {
        self.owner = owner
        self.targetView = targetView
    }

    public func setupPopover() {
        owner.view.superview?.layer.cornerRadius = 0
        if targetView is IBIncludingView, let color = targetView?.subviews.first?.backgroundColor {
            // set background to match targetView first child (with IBIncludables, this is the real root view)
            PopoverBackgroundView.CustomBackgroundColor = color
            owner.popoverPresentationController?.backgroundColor = color
        } else if let color = targetView?.backgroundColor {
            // set background to match targetView
            PopoverBackgroundView.CustomBackgroundColor = color
            owner.popoverPresentationController?.backgroundColor = color
        }
    }
    
    public func layoutPopover() {
        let screenBounds = UIScreen.mainScreen().bounds
        if let bounds = targetView?.bounds where bounds != lastTargetBounds && screenBounds != lastScreenBounds {
            lastTargetBounds = targetView?.bounds
            lastScreenBounds = screenBounds
            var size = bounds.size
            if size.height > screenBounds.height - (PopoverValues.PopoverPadding * 2) {
                size.height = screenBounds.height - (PopoverValues.PopoverPadding * 2)
            }
            owner.preferredContentSize = size
        }
    }
    
}
