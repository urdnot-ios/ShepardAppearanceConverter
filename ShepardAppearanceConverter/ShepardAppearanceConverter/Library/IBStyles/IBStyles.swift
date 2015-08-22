//
//  IBStyles.swift
//
//  Created by Emily Ivie on 2/24/15.
//

import UIKit

//MARK: IBStylePropertyName
/**
    All the current possible IBStyle options.
    Note: neither StateX or IPad|IPhoneStyles are properly visible in Interface Builder. 
        Use the @IBInspectable properties in IBStyledButton and IBStyledRootView to set them.

    - Inherit: expects a string of IBStyle names. Applies them in order listed, with current styles taking precedence.
    - IPadStyles: an IBStyleProperties list of styles to only apply when on an iPad device.
    - IPhoneStyles: an IBStyleProperties list of styles to only apply when on an iPhone device.
    - Font: add new fonts to IBFont enum. This field will only accept IBFont enum values.
    - TextColor: UIColor
    - CornerRadius: Double
    - BorderWidth: Double
    - BorderColor: UIColor
    - BackgroundColor: UIColor
    - BackgroundGradient: see IBGradient. Example: IBGradient(direction:.Vertical, colors:[UIColor.redColor(),UIColor.blackColor()])
    - StateActive: an IBStyleProperties list of styles to only apply when button is active.
    - StatePressed: an IBStyleProperties list of styles to only apply when button is pressed.
    - StateDisabled: an IBStyleProperties list of styles to only apply when button is disabled.
    - StateSelected: an IBStyleProperties list of styles to only apply when button is selected. Dunno when that is.
*/
public enum IBStylePropertyName {
    case Inherit //[String]
    
    case IPadStyles //IBStyleProperties
    case IPhoneStyles //IBStyleProperties
    //size-specific styles?
    
    case Font //IBFont
    case TextColor //UIColor
    case CornerRadius //Double
    case CircleMask //Bool
    case BorderWidth //Double
    case BorderColor //UIColor
    case BackgroundColor //UIColor
    case BackgroundGradient //IBGradient
    
    case StateActive //IBStyleProperties
    case StatePressed //IBStyleProperties
    case StateDisabled //IBStyleProperties
    case StateSelected //IBStyleProperties
}

public typealias IBStyleProperties = [IBStylePropertyName: Any]
public typealias IBStyleGroup = [String: IBStyleProperties]


//MARK: IBStyles
/**
    The base functionality for applying IBStyles to an IBStylable element.
    Stores all styles in a static/shared struct.
*/
public struct IBStyles {

    // I can't figure out any way to let Styles write to IBStyles at IB app load since appDelegate is never called in IB :(
    // So, this kinda sucks:
    
    public static var stylesList: [String: IBStyleProperties] = Styles.stylesList // [:]
    public static var fontsList: [IBFontStyle: String] = Styles.fontsList // [:] // http://iosfonts.com/
    public static var deviceKind = UIDevice.currentDevice().userInterfaceIdiom ?? UIUserInterfaceIdiom.Phone
    
    /**
        Verify that all styles are the expected type.
    */
    private static func validate(properties: IBStyleProperties) {
        for (type,value) in properties{
            switch (type){
                case .Inherit: assert(value as? [String] != nil)
                
                case .IPadStyles: fallthrough
                case .IPhoneStyles:
                    assert(value as? IBStyleProperties != nil)
                    validate(value as! IBStyleProperties)
                
                case .Font: assert(value as? IBFont != nil)
                case .TextColor: assert(value as? UIColor != nil)
                case .CornerRadius: assert(value as? Double != nil)
                case .CircleMask: assert(value as? Bool != nil)
                case .BorderWidth: assert(value as? Double != nil)
                case .BorderColor: fallthrough
                case .BackgroundColor: assert(value as? UIColor != nil)
                case .BackgroundGradient: assert(value as? IBGradient != nil) //what if I add other gradients?
                
                case .StateActive: fallthrough
                case .StatePressed: fallthrough
                case .StateDisabled: fallthrough
                case .StateSelected:
                    assert(value as? IBStyleProperties != nil)
                    validate(value as! IBStyleProperties)
            }
        }
    }

    /**
        Assembles a list of styles for this element, in order of priority (inherit, main, device).
        
        :param: identifier      the key of the element
        :param: to (element)    the element to be styled
    */
    public static func apply(identifier: String, to element: UIView!) {
        if let properties = stylesList[identifier] {
            let inheritProperties = properties[.Inherit] as? [String] ?? []
            var properties2 = IBStyleProperties()
            for name in inheritProperties {
                if let styles = stylesList[name] {
                    properties2.merge(styles)
                }
            }
            properties2 = mergeDeviceStyles( properties2.merge(properties) )
            applyProperties(properties2, to: element)
        }
    }
    
    /**
        A special-case version of apply() that only applies state-specific styles.
        This allows for only changing specific styles rather than rewriting everything.
        
        :param: identifier      the key of the element
        :param: to (element)    the element to be styled
        :param: forState        the UIControlState in play: Normal, Disabled, Highlighted, or Selected
    */
    public static func apply(identifier: String, to element: UIView!, forState state: UIControlState) {
        var properties = stylesList[identifier] ?? [:]
        switch (state) {
            case UIControlState.Normal :
                if let p2 = properties[.StateActive] as? IBStyleProperties {
                    properties = p2
                }
            case UIControlState.Disabled :
                if let p2 = properties[.StateDisabled] as? IBStyleProperties {
                    properties = p2
                }
            case UIControlState.Highlighted :
                if let p2 = properties[.StatePressed] as? IBStyleProperties {
                    properties = p2
                }
            case UIControlState.Selected :
                if let p2 = properties[.StateSelected] as? IBStyleProperties {
                    properties = p2
                }
            default:
                return //don't do anything
        }
        applyProperties(properties, to: element, forState: state)
    }
    
    /**
        Adds in device-specific styles (if any exist). These override higher-level styles.
    */
    private static func mergeDeviceStyles(var properties: IBStyleProperties) -> (IBStyleProperties) {
        if let ipad = properties[.IPadStyles] as? IBStyleProperties {
            if deviceKind == UIUserInterfaceIdiom.Pad {
                properties.merge(ipad)
                return properties
            }
        }
        if let iphone = properties[.IPhoneStyles] as? IBStyleProperties {
            if deviceKind == UIUserInterfaceIdiom.Phone {
                properties.merge(iphone)
                return properties
            }
        }
        return properties
    }

    /**
        Applies a list of styles to an element
        
        :param: properties      the list of styles
        :param: to (element)    the element to be styled
        :param: forState        (Optional) the UIControlState in play - defaults to normal
    */
    private static func applyProperties(properties: IBStyleProperties, to element: UIView!, forState state: UIControlState = .Normal) {
        guard element != nil else { return }
        for (type, value) in properties {
//            let elementState: UIControlState? //for later
            switch (type){
            
                case .Font:
                    if let fontClass = value as? IBFont {
                        if let font = fontClass.getUIFont() {
                            if let label = element as? UILabel {
                                label.font = font
                            }
                            if let button = element as? UIButton {
                                button.titleLabel?.font = font
                            }
                            if let textfield = element as? UITextField {
                                textfield.font = font
                            }
                            if let textview = element as? UITextView {
                                textview.font = font
                            }
                        }
                    }
                
                case .TextColor:
                    if let color = value as? UIColor {
                        if let label = element as? UILabel {
                            label.textColor = color
                        }
                        if let button = element as? UIButton {
                            button.setTitleColor(color, forState: state)
                        }
                        if let textfield = element as? UITextField {
                            textfield.textColor = color
                        }
                        if let textview = element as? UITextView {
                            textview.textColor = color
                        }
                    }
                
                case .CornerRadius:
                    element.layer.cornerRadius = CGFloat(value as? Double ?? 0.0)
                    element.layer.masksToBounds = element.layer.cornerRadius > CGFloat(0)
                
                case .CircleMask:
                    if let useValue = value as? Bool where useValue {
                        element.layer.cornerRadius = element.frame.size.width / 2.0
                        element.layer.masksToBounds = true
                    }
                
                case .BorderWidth:
                    element.layer.borderWidth = CGFloat(value as? Double ?? 0.0)
                
                case .BorderColor:
                    if let color = value as? UIColor {
                        element.layer.borderColor = (color).CGColor
                    }
                
                case .BackgroundColor:
                    if let color = value as? UIColor {
                        element.layer.backgroundColor = color.CGColor
                    }
                
                case .BackgroundGradient:
                    if let gradient = value as? IBGradient {
                        let gradientView = gradient.createGradientView(element.bounds)
                        element.insertSubview(gradientView, atIndex: 0)
                        gradientView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
                    }
                
                // And now, state-specific styles:
                /*
                // currently disabled, because not all styles can be set forState, so have to change dynamically on events
                // see IBStyledButton for more
                case .StateActive:
                    if let p2 = value as? IBStyleProperties {
                        applyProperties(p2, to: element, forState: .Normal)
                    }
                case .StatePressed:
                    if let p2 = value as? IBStyleProperties {
                        applyProperties(p2, to: element, forState: .Highlighted)
                    }
                case .StateDisabled:
                    if let p2 = value as? IBStyleProperties {
                        applyProperties(p2, to: element, forState: .Disabled)
                    }
                case .StateSelected:
                    if let p2 = value as? IBStyleProperties {
                        applyProperties(p2, to: element, forState: .Selected)
                    }
                */
                
                default: break //skip the rest
            }
        }
    }
}

//MARK: IBFont

public enum IBFontStyle: String {
    case Normal, Italic, Medium, SemiBold, Bold
}

public enum IBFont {
    case SizeStyle(Int,IBFontStyle)
    
    public func getUIFont() -> UIFont? {
        switch(self) {
        case .SizeStyle(let size, let style):
            let name = IBStyles.fontsList[style]
            let cgSize = CGFloat(size)
            switch style {
            case .Normal: return name != nil ? UIFont(name: name!, size: cgSize) : UIFont.systemFontOfSize(cgSize)
            case .Italic: return name != nil ? UIFont(name: name!, size: cgSize) : UIFont.italicSystemFontOfSize(cgSize)
            case .Medium: return name != nil ? UIFont(name: name!, size: cgSize) : UIFont.systemFontOfSize(cgSize)
            case .SemiBold: return name != nil ? UIFont(name: name!, size: cgSize) : UIFont.boldSystemFontOfSize(cgSize)
            case .Bold: return name != nil ? UIFont(name: name!, size: cgSize) : UIFont.boldSystemFontOfSize(cgSize)
            }
        }
    }
}

//MARK: IBGradient
/**
    Just a helpful way to define background gradients. 
    See CAGradientLayer for more information on the properties used here.

    - direction: .Vertical or .Horizontal
    - colors
    - locations
    - createGradientView()
*/
public struct IBGradient {
    /**
        Quick enum to more clearly define IBGradient direction (Vertical or Horizontal).
    */
    public enum Direction {
        case Vertical,Horizontal
    }
    public var direction: Direction = .Vertical
    public var colors: [UIColor] = []
    public var locations: [Double] = []
    
    init(direction: Direction, colors: [UIColor]){
        self.direction = direction
        self.colors = colors
    }
    
    /**
        Generates a IBGradientView from the gradient values provided.
    
        :param: bounds  The size to use in creating the gradient view.
        :returns:       a UIView with a gradient background layer
    */
    public func createGradientView(bounds: CGRect) -> (IBGradientView) {
        let gradientView = IBGradientView(frame: bounds)
        gradientView.setLayerColors(colors)
        if locations.count > 0 {
            gradientView.setLayerLocations(locations)
        } else {
            gradientView.setLayerEndPoint(direction == .Vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0))
        }
        return gradientView
    }
}

//MARK: IBGradientView
/**
    Allows for an auto-resizable CAGradientLayer (like, say, during device orientation changes).

    IBStyles IBStylePropertyName.BackgroundGradient uses this.
*/
public class IBGradientView: UIView {
    /**
        Built-in UIView function that responds to .layer requests.
        Changes the .layer property of the view to be CAGradientLayer. But we still have to change all interactions with .layer to recognize this new type, hence the other functions.
        
        :returns: CAGradientLayer .layer reference
    */
    override public class func layerClass() -> (AnyClass) {
        return CAGradientLayer.self
    }
    /**
        Sets the colors of the gradient. Can be more than two.
        
        :param: colors  a list of UIColor elements.
    */
    public func setLayerColors(colors: [UIColor]) {
        let layer = self.layer as! CAGradientLayer
        layer.colors = colors.map({ $0.CGColor })
    }
    /**
        Sets the locations of the gradient. See CAGradientLayer documentation for how this work, because I only used endPoint myself.
        
        :param: locations  a list of Double location positions.
    */
    public func setLayerLocations(locations: [Double]) {
        let layer = self.layer as! CAGradientLayer
        layer.locations = locations.map({ NSNumber(double: $0) })
    }
    /**
        Sets the start point of the gradient (this is the simplest way to define a gradient: setting the start or end point)
        
        :param: startPoint  a CGPoint using 0.0 - 1.0 values
    */
    public func setLayerStartPoint(startPoint: CGPoint) {
        let layer = self.layer as! CAGradientLayer
        layer.startPoint = startPoint
    }
    /**
        Sets the end point of the gradient (this is the simplest way to define a gradient: setting the start or end point)
        
        :param: endPoint  a CGPoint using 0.0 - 1.0 values
    */
    public func setLayerEndPoint(endPoint: CGPoint) {
        let layer = self.layer as! CAGradientLayer
        layer.endPoint = endPoint
    }
}

