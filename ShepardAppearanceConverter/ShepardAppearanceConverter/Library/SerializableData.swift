//
//  SerializableData.swift
//
//  Copyright 2015 Emily Ivie

//  Licensed under The MIT License
//  For full copyright and license information, please see http://opensource.org/licenses/MIT
//  Redistributions of files must retain the above copyright notice.
//

import Foundation


public enum SerializableDataError : ErrorType {
    case ParsingError
    case TypeMismatch
}


//MARK: Protocol to define serializable types:
// (can be extended to any type you want, just implement getData)

public protocol SerializableDataType { // any struct or object can be stored in SerializableData, provided it adheres to this
    func getData() -> SerializableData
}
extension SerializableDataType {
    public func getData() -> SerializableData { return SerializableData(self) }
}
extension Bool: SerializableDataType {}
extension String: SerializableDataType {}
extension NSString: SerializableDataType {}
extension Int: SerializableDataType {}
extension Double: SerializableDataType {}
extension NSNumber: SerializableDataType {}
extension NSDate: SerializableDataType {}
extension NSNull: SerializableDataType {}

/**
 * Example:
 *
        let x = SerializableData(["something": 3.05] as [String: SerializableDataType])
        print(x["something"]?.string) //Optional("3.05")
        print(x["something"]?.double) //Optional(3.05)
*/
public struct SerializableData {

    //MARK: Contents
    
    internal enum StorageType {
        case Null
        case ValueType(SerializableDataType)
        case DictionaryType([String: SerializableData])
        case ArrayType([SerializableData])
        
        internal func isNull() -> Bool {
            if case .Null = self { return true } else { return false }
        }
        internal func isValue() -> Bool {
            if case .ValueType(_) = self { return true } else { return false }
        }
        internal func isDictionary() -> Bool {
            if case .DictionaryType(_) = self { return true } else { return false }
        }
        internal func isArray() -> Bool {
            if case .ArrayType(_) = self { return true } else { return false }
        }
    }
    internal var contents = StorageType.Null
    
    //MARK: Initializers
    
    public init() {}
    
    public init(_ data: SerializableDataType?) {
        if data is NSNull || data == nil {
            // do nothing
        } else if let vDate = data as? NSDate, let sDate = stringFromDate(vDate) {
            // dates cause problems in nsData and jsonString, so for now we are stringifying first :/
            contents = .ValueType(sDate)
        } else {
            contents = .ValueType(data!)
        }
    }
    public init(_ data: [SerializableDataType]) {
        contents = .ArrayType(data.map { $0.getData() })
    }
    public init(_ data: [SerializableDataType?]) {
        contents = .ArrayType(data.map { $0?.getData() ?? SerializableData() })
    }
    public init(_ data: [SerializableData]) {
        contents = .ArrayType(data)
    }
    public init(_ data: [String: SerializableDataType]) {
        contents = .DictionaryType( Dictionary( data.map { ($0.0, $0.1.getData()) } ))
    }
    public init(_ data: [String: SerializableDataType?]) {
        contents = .DictionaryType( Dictionary( data.map { ($0.0, $0.1?.getData() ?? SerializableData()) } ))
    }
    public init(_ data: [String: SerializableData]) {
        contents = .DictionaryType(data)
    }
    
    //MARK: Throws initializers (try to use one of the ones above instead, if at all possible)
    
    /// - Parameter data: a variety of data that can be categorized as AnyObject. Anything not SerializableDataType at some level will eventually be rejected and throw error. NSNull is acceptable.
    public init(data: AnyObject) throws {
        if let a = data as? [AnyObject] {
            var aValues = [SerializableData]()
            for (value) in a { aValues.append( try SerializableData(data: value) ) }
            contents = .ArrayType(aValues)
        } else if let d = data as? [String: AnyObject] {
            var dValues = [String: SerializableData]()
            for (key, value) in d { dValues[key] = try SerializableData(data: value) }
            contents = .DictionaryType(dValues)
        } else if let v = data as? SerializableDataType {
            contents = .ValueType(v)
        } else if data is NSNull {
            // do nothing
        } else {
            throw SerializableDataError.ParsingError
        }
    }

    /// - Parameter jsonData: parses a json list of NSData format. Throws error if it can't parse it/make it SerializableData.
    public init(jsonData: NSData) throws {
        do {
            let data = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
            try self.init(data: data)
        } catch {
            throw SerializableDataError.ParsingError
        }
    }
    
    /// - Parameter jsonString: parses a json-formatted string. Throws error if it can't parse it/make it SerializableData.
    public init(jsonString: String) throws {
        if let data = (jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding) {
            try self.init(jsonData: data)
        } else {
            throw SerializableDataError.ParsingError
        }
    }
}

extension SerializableData {

    //MARK: Return stored data
    
    /// - Returns: Whatever type requested, if it is possible to convert the data into that format.
    public func value<T>() -> T? {
        let formatter = NSNumberFormatter()
        switch contents {
        case .Null: return nil
        case .ValueType(let v):
            if let tValue = v as? T {
                return tValue
            }
            let s = String(v)
            // fun times: json is often ambiguous about whether it's a string or a number
            if let tValue = NSString(string: s).boolValue as? T {
                return tValue
            } else if let tValue = formatter.numberFromString(s)?.integerValue as? T {
                return tValue
            } else if let tValue = formatter.numberFromString(s)?.floatValue as? T {
                return tValue
            } else if let tValue = formatter.numberFromString(s)?.doubleValue as? T {
                return tValue
            } else if let tValue = dateFromString(s) as? T {
                return tValue
            } else if let tValue = formatter.numberFromString(s) as? T { //NSNumber
                return tValue
            } else if let tValue = s as? T { // string requested
                return tValue
            }
            return nil
        case .DictionaryType(let d):
            if let tValue = d as? T {
                return tValue
            } else {
                return nil
            }
        case .ArrayType(let a):
            if let tValue = a as? T {
                return tValue
            } else {
                return nil
            }
        }
    }
    
    /// - Returns: Optional(String) if this object can be one (most things can)
    public var string: String? { return value() as String? }
    /// - Returns: Optional(Bool) if this object can be converted to one
    public var bool: Bool? { return value() as Bool? }
    /// - Returns: Optional(Int) if this object can be converted to one
    public var int: Int? { return value() as Int? }
    /// - Returns: Optional(Float) if this object can be converted to one
    public var float: Float? { return value() as Float? }
    /// - Returns: Optional(Double) if this object can be converted to one
    public var double: Double? { return value() as Double? }
    /// - Returns: Optional(NSNumber) if this object can be converted to one
    public var nsNumber: NSNumber? { return value() as NSNumber? }
    /// - Returns: Optional(NSDate) if this object can be converted to one
    public var date: NSDate? { return value() as NSDate? }
    
    /// - Parameter value: A date string of format "YYYY-MM-dd HH:mm:ss"
    /// - Returns: Optional(NSDate)
    private func dateFromString(value: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        //add more flexible parsing later?
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let date = dateFormatter.dateFromString(value)
        return date
    }
    
    /// - Parameter value: NSDate
    /// - Returns: Optional(String) of format "YYYY-MM-dd HH:mm:ss"
    private func stringFromDate(value: NSDate) -> String? {
        let dateFormatter = NSDateFormatter()
        //add more flexible parsing later
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        return dateFormatter.stringFromDate(value)
    }
    
}
    
extension SerializableData {

    //MARK: subscript and array access
    
    // SerializableData does not implement full sequence/collection type because you should be using .array and .dictionary instead (trust me, you will find it is far easier when dealing with mixed data-!).
    // But I've included append and subscript just to make editing your data a little bit easier.
    
    public subscript(index: String) -> SerializableData? {
        get {
            if case .DictionaryType(let d) = contents {
                return d[index]
            }
            return nil
        }
        set {
            if case .DictionaryType(let d) = contents {
                var newDictionary: [String: SerializableData] = d
                newDictionary[index] = newValue ?? SerializableData()
                contents = .DictionaryType(newDictionary)
            } else if case .Null = contents {
                contents = .DictionaryType([index: newValue ?? SerializableData()] as [String: SerializableData])
            } else {
                assert(false, "Key does not point to dictionary-type data")
                // someday: throw SerializableDataError.TypeMismatch
            }
        }
    }
    public subscript(index: Int) -> SerializableData? {
        get {
            if case .ArrayType(let a) = contents {
                return a[index]
            }
            return nil
        }
        set {
            if case .ArrayType(let a) = contents {
                var newArray: [SerializableData] = a
                newArray.append(newValue ?? SerializableData())
                contents = .ArrayType(newArray)
            } else if case .Null = contents {
                contents = .ArrayType([newValue ?? SerializableData()] as [SerializableData])
            } else {
                assert(false, "Key does not point to array-type data")
                // someday: throw SerializableDataError.TypeMismatch
            }
        }
    }
    
    /// - Parameter value: Any value type. If value cannot be converted to SerializableData, or if this SerializableData object is not an array, then it throws error. (If this object is .Null, then it changes to an array of the new value.)
    public mutating func append<T>(value: T?) throws {
        guard case .ArrayType(let a) = contents else {
            throw SerializableDataError.TypeMismatch
        }
        var newArray: [SerializableData] = a
        let newValue: SerializableData = try {
            switch value {
            case let v as [SerializableData]: return SerializableData(v)
            case let v as [SerializableDataType?]: return SerializableData(v)
            case let v as [String: SerializableData]: return SerializableData(v)
            case let v as [String: SerializableDataType?]: return SerializableData(v)
            case let v as SerializableDataType: return SerializableData(v)
            case nil: return SerializableData()
            default: throw SerializableDataError.TypeMismatch
            }
        }()
        newArray.append(newValue)
        contents = .ArrayType(newArray)
    }
    
    /// - Returns: A dictionary if this object is one
    public var dictionary: [String: SerializableData]? {
        if case .DictionaryType(let d) = contents {
            return d
        }
        return nil
    }
    
    /// - Returns: An array if this object is one
    public var array: [SerializableData]? {
        if case .ArrayType(let a) = contents {
            return a
        }
        return nil
    }
}


extension SerializableData {
    
    //MARK: formatting data for other uses
    
    /// - Returns: AnyObject (closest to the format used to create the SerializableData object originally)
    var anyObject: AnyObject {
        switch contents {
        case .ValueType(let v):
            return v as? AnyObject ?? NSNull()
        case .DictionaryType(let d):
            let list = NSMutableDictionary()
            for (key, value) in d {
                list[key] = value.anyObject
            }
            return list
        case .ArrayType(let a):
            let list = NSMutableArray()
            for (value) in a {
                list.addObject(value.anyObject)
            }
            return list
        default:
            return NSNull()
        }
    }

    /// - Returns: An NSData object
    var nsData: NSData? {
        if case .Null = contents {
            // can't make a json object with *just* nil (NSNull inside array/dictionary is okay)
            return nil
        }
        do {
            return try NSJSONSerialization.dataWithJSONObject(anyObject, options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            return nil
        }
    }
    
    //MARK: jsonString
    
    /// - Returns: A flattened json string
    public var jsonString: String {
        switch contents {
        case .ValueType(let v): return "\(v)"
        case .DictionaryType(_): fallthrough
        case .ArrayType(_):
            if let d = nsData, let jsonString = NSString(data: d, encoding: NSUTF8StringEncoding) as? String {
                return jsonString
            }
            fallthrough
        default: return ""
        }
    }

    //MARK: urlString
    
    /// - Returns: A flattened String in format "key=value&key=value"
    public var urlString: String {
        switch contents {
        case .ValueType(_): return SerializableData.urlEncode(self.jsonString)
        case .DictionaryType(let d): return SerializableData.urlString(d)
        case .ArrayType(let a): return SerializableData.urlString(a)
        default: return ""
        }
    }
    
    /// - Parameter list: a dictionary to convert
    /// - Parameter prefix: - an optional prefix to use before the key (necessary for nested data)
    /// - Returns: A flattened String in format "key=value&key=value"
    public static func urlString(list: [String: SerializableData], prefix: String = "") -> String {
        var urlStringValue = String("")
        for (key, value) in list {
            let prefixedKey = prefix != "" ? "\(prefix)[\(key)]" : key
            switch value.contents {
            case .ValueType(let v): urlStringValue += "\(urlEncode(prefixedKey))=\(urlEncode(v))&"
            case .DictionaryType(let d): urlStringValue += "\(urlString(d, prefix: prefixedKey))&"
            case .ArrayType(let a): urlStringValue += "\(urlString(a, prefix: prefixedKey))&"
            default: urlStringValue += "\(self.urlEncode(prefixedKey))=&"
            }
        }
        return urlStringValue.isEmpty ? "" : urlStringValue.stringFrom(0, to: -1)
    }
    
    /// - Parameter list: an array to convert
    /// - Parameter prefix: - an optional prefix to use before the key (necessary for nested data)
    /// - Returns: A flattened String in format "key=value&key=value"
    public static func urlString(list: [SerializableData], prefix: String = "") -> String {
        var urlStringValue = String("")
        for (value) in list {
            let prefixedKey = prefix != "" ? "\(prefix)[]" : ""
            let prefixHere = prefixedKey != "" ? "\(self.urlEncode(prefixedKey))=" : ""
            switch value.contents {
            case .ValueType(let v): urlStringValue += prefixHere + urlEncode(v) + "&"
            case .DictionaryType(let d): urlStringValue += "\(urlString(d, prefix: prefixedKey))&"
            case .ArrayType(let a): urlStringValue += "\(urlString(a, prefix: prefixedKey))&"
            default: urlStringValue += prefixHere + ","
            }
        }
        return urlStringValue.isEmpty ? "" : urlStringValue.stringFrom(0, to: -1)
    }

    /// - Parameter unescaped: The string to be escaped
    /// - Returns: An escaped String in format "something%20here"
    static func urlEncode(unescaped: SerializableDataType) -> String {
        if !(unescaped is NSNull), let escaped = "\(unescaped)".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) {
            return escaped
        }
        return ""
    }
}


extension SerializableData: SerializableDataType {
    public func getData() -> SerializableData { return self }
}
