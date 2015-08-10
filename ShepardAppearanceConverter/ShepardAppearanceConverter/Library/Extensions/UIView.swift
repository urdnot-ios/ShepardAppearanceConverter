//
//  UIView.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/30/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

extension UIView {
    public func constraintAllEdgesEqualTo(view: UIView!) {
        leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
    }
    public func constraintCenterTo(view: UIView!) {
        centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
    }
    
//    // Just an idea, not yet tested
//    public func replaceViewKeepConstraints(view: UIView){
//        if let constraints = view.constraints() as? [NSLayoutConstraint] {
//            for constraint in constraints {
//                if constraint.firstItem === view {
//                    var newConstraint = constraint
//                    newConstraint.firstItem = self
//                    addConstraint(newConstraint)
//                }
//                if constraint.secondItem === view {
//                    var newConstraint = constraint
//                    newConstraint.secondItem = self
//                    addConstraint(newConstraint)
//                }
//            }
//        }
//        view.superview?.insertSubview(self, aboveSubview: view)
//        view.removeFromSuperview()
//    }
}
