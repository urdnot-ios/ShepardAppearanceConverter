//
//  IBStylable.swift
//
//  Created by Emily Ivie on 3/4/15.
//

import UIKit
/**
    Delegate Protocol for IBStyler. I did not name it IBStylerDelegate because the communication goes both ways.
    Have to use @objc to use optional. With @objc, cannot use Swift-specific variables.
*/
@objc protocol IBStylable { // Maybe should just call it IBStyled to match IBStyledView, etc (or name them IBStylableView?).

    var styler: IBStyler { get } // Delegate talking goes both ways on this one.
    var identifier: String! { get }
    optional var defaultIdentifier: String { get }
    
    optional func applyStyles()
    
}

/**
    Applies IBStyles to IBStylable elements. It does not auto-detect when and how to do this, alas,
        so each IBStylable element has to call home to it in order to trigger events.
        Call applyStyles() inside IBStylable's prepareForInterfaceBuilder() or layoutSubviews().
*/
public class IBStyler: NSObject {

    private var delegate: IBStylable!
    
    internal var didApplyStyles = false

    init(delegate: IBStylable) {
        super.init()
        self.delegate = delegate
        // BTW, delegate's identifier is not usually available at the time a delegate's init() is called. Sorry.
    }
    
    internal var delegateIdentifier: String {
        return (delegate?.identifier ?? delegate?.defaultIdentifier) ?? ""
    }
    
    /**
        Only applies IBStyles once. Apply layout stuff separately in subclassed layout subviews (sorry, no better way yet).
    */
    public func applyStyles() {
        if !didApplyStyles && !delegateIdentifier.isEmpty {
            IBStyles.apply(delegateIdentifier, to: delegate as? UIView)
        }
        delegate.applyStyles?()
        didApplyStyles = true
    }
    
    /**
        A special function for IBStyledButton elements to change state-specific styles 
            on state-changing events (see IBStyledButton for more)
    */
    public func applyState(state:UIControlState){
        //changes only styles specific to a state, also ignores didApplyFormat flag
        if !delegateIdentifier.isEmpty {
            IBStyles.apply(delegateIdentifier, to: delegate as? UIView, forState: state)
        }
    }

}