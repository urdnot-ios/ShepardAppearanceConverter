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
    
    optional var previewIPad: Bool { get }
    optional var previewIPhone: Bool { get }
    
    optional func applyLayout()
    optional func applyFormat()
    
}

/**
    Applies IBStyles to IBStylable elements. It does not auto-detect when and how to do this, alas,
        so each IBStylable element has to call home to it in order to trigger events.
        Call applyStyles() inside IBStylable's prepareForInterfaceBuilder() or layoutSubviews().
*/
public class IBStyler: NSObject {

    private var delegate: IBStylable!
    
    internal var lastViewBounds: CGRect?
    internal var didApplyFormat = false
    internal var didAddExtendedStyles = false

    init(delegate: IBStylable) {
        super.init()
        self.delegate = delegate
        // BTW, delegate's identifier is not usually available at the time a delegate's init() is called. Sorry.
    }

    /**
        Determines if the screen size has changed, which would happen during layout or on device rotation.
        Not needed so much once I figured out how to cut down on calls to applyStyles(), 
            but maybe if we do more sizing stuff inside IBStyles.
            
        :returns: True/False if screen size has changed
    */
    public func boundsChanged() -> Bool {
        if (lastViewBounds == nil) { return true }
        let changed = (lastViewBounds != (delegate as? UIView)?.bounds)
        lastViewBounds = (delegate as? UIView)?.bounds
        return changed
    }
    
    internal var delegateIdentifier: String {
        return (delegate?.identifier ?? delegate?.defaultIdentifier) ?? ""
    }
    
    /**
        Only applies IBStyles once (called applyFormat()), and if that is not prepareForInterfaceBuilder() in Interface Builder, 
            will probably call it too soon (Interface Builder calls layoutSubviews() a million times, 
            and most of those times the element is not correctky placed inside the View hierarchy).
        applyLayout() is currently not used by IBStyler, but that may change if we start allowing layout styles (like width/height).
    */
    public func applyStyles() {
        if !didApplyFormat {
            applyFormat()
        }
        if boundsChanged() {
            applyLayout()
        }
    }
    
    /**
        Applies IBStyles. If we add layout styles (like width/height), we will need to alter IBStyles/IBStylesShell
            to differentiate, and only apply format styles here, with layout styles applies inside applyLayout().
        Maybe needs a better name?
    */
    public func applyFormat() {
        if !didApplyFormat && !delegateIdentifier.isEmpty {
            IBStyles.apply(delegateIdentifier, to: delegate as? UIView)
            // eventually restrict to format styles only,
            // add layout styles under applyLayout() instead
        }
        delegate.applyFormat?()
        didApplyFormat = true
    }
    
    /**
        Intended to apply layout styles (like width/height), but there are none right now,
            so just kicks it back to the delegate, in case the delegate has some fomatting things to do.
    */
    public func applyLayout() {
        delegate.applyLayout?()
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
    
    /**
        Initializes the device type referenced by IBStyles.
        Currently only used by IBStyledRootView - can be overridden there using @IBInspectable Preview IPad/IPhone.
    */
    public func setDeviceType(){
        var setIPad:Bool = false
        var setIPhone:Bool = false
        if delegate.previewIPad != nil {
            if delegate.previewIPad! {
                IBStyles.deviceKind = .Pad
                setIPad = true
            }
        }
        if delegate.previewIPhone != nil {
            if delegate.previewIPhone! {
                IBStyles.deviceKind = .Phone
                setIPhone = true
            }
        }
        assert(!(setIPad && setIPhone))
    }

}