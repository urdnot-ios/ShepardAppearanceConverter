//
//  HideAutolayoutUtility.swift
//
//  Created by Emily Ivie on 6/11/15.
//

import UIKit

/**
    Hides a view and removes any constraints tied to it, which can allow for space to collapse when view is gone. 

    Allows for all autolayout to be defined in Interface Builder. Just provide two constraints, a strong one for when the item is visible, and a weaker one for when it is hidden (so, 8 to itemToBeHidden at priority 1000, 8 to previousItem at priority 100), and the weaker one will kick in when the item is hidden. DO NOT USE >= weaker constraints, because then it will just stick with the previous layout and not collapse the space.
    
    Derived from https://gist.github.com/albertbori/9716fd25b424950264eb
*/
public class HideAutolayoutUtility {

    var savedConstraints = [String: [NSLayoutConstraint]]()

    init() {}
    
    public func hide(view: UIView!, key: String) {
//        println("\(key) HIDE")
        if view == nil { return }
        view.hidden = true
        if let parent = view.superview {
            let constraints = parent.constraints
            var removeConstraints = [NSLayoutConstraint]()
            for constraint in constraints {
                if constraint.firstItem === view || constraint.secondItem === view {
//                    println("\(key) \(constraint)")
                    removeConstraints.append(constraint)
                }
            }
            savedConstraints[key] = removeConstraints
            parent.removeConstraints(removeConstraints)
        }

    }
    
    public func show(view: UIView!, key: String) {
//        println("\(key) SHOW")
        if view == nil { return }
        view.hidden = false
        if let constraints = savedConstraints[key], let parent = view.superview {
            parent.addConstraints(constraints)
            savedConstraints.removeValueForKey(key)
        }
    }
}
