//
//  SerializedData.swift
//
//  Copyright 2015 Emily Ivie

//  Licensed under The MIT License
//  For full copyright and license information, please see http://opensource.org/licenses/MIT
//  Redistributions of files must retain the above copyright notice.
//

import Foundation


public enum SerializedDataError : ErrorType {
    case ParsingError
    case TypeMismatch
    case MissingRequiredField
}

public enum SerializedDataOrigin {
    case Database
    case LocalStore
    case DataChange
}

//MARK: SerializedDataStorable Protocol
// (can be extended to any type you want, just implement getData)

public protocol SerializedDataStorable { // any struct or object can be stored in SerializedData, provided it adheres to this
    var serializedData: String { get }
    func getData() -> SerializedData
}
public protocol SerializedDataRetrievable {
    init(serializedData: String) throws
    mutating func setData(data: SerializedData)
    mutating func setData(serializedData json: String) throws
}


/**
 * Example:
 *
        let x = SerializedData(["something": 3.05] as [String: SerializedDataStorable])
        print(x["something"]?.string) //Optional("3.05")
        print(x["something"]?.double) //Optional(3.05)
*/
public struct SerializedData {
//MARK: Contents
    
    internal enum StorageType {
        case None
        case ValueType(SerializedDataStorable)
        case DictionaryType([String: SerializedData])
        case ArrayType([SerializedData])
        
        internal func isNone() -> Bool {
            if case .None = self { return true } else { return false }
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
    internal var contents = StorageType.None
    
    //MARK: Initializers
    
    public init() {}
    
    public init(_ data: SerializedDataStorable?) {
        if let data = data {
            if let SerializedData = data as? SerializedData {
                self = SerializedData
            } else if let vDate = data as? NSDate, let sDate = stringFromDate(vDate) {
                // dates cause problems in nsData and jsonString, so for now we are stringifying first :/
                contents = .ValueType(sDate)
            } else {
                contents = .ValueType(data)
            }
        } else {
            // do nothing - leave .None
        }
    }
    public init(_ data: [SerializedData]) {
        contents = .ArrayType(data)
    }
    public init(_ data: [SerializedDataStorable?]) {
        self = data.getData()
    }
    public init(_ data: [String: SerializedData]) {
        contents = .DictionaryType(data)
    }
    public init(_ data: [String: SerializedDataStorable?]) {
        self = data.getData()
    }
    
    //MARK: Throws initializers (try to use one of the ones above instead, if at all possible)
    
    /// - Parameter data: a variety of data that can be categorized as AnyObject. Anything not SerializedDataStorable at some level will eventually be rejected and throw error. NSNull is acceptable.
    public init(anyData data: AnyObject) throws {
        if let a = data as? [AnyObject] {
            var aValues = [SerializedData]()
            for (value) in a { aValues.append( try SerializedData(anyData: value) ) }
            contents = .ArrayType(aValues)
        } else if let d = data as? [String: AnyObject] {
            var dValues = [String: SerializedData]()
            for (key, value) in d { dValues[key] = try SerializedData(anyData: value) }
            contents = .DictionaryType(dValues)
        } else if data is NSNull {
            // do nothing
        } else if let v = data as? SerializedDataStorable {
            contents = .ValueType(v)
        } else {
            throw SerializedDataError.ParsingError
        }
    }

    /// - Parameter jsonData: parses a json list of NSData format. Throws error if it can't parse it/make it SerializedData.
    public init(jsonData: NSData) throws {
        do {
            let data = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
            try self.init(anyData: data)
        } catch {
            throw SerializedDataError.ParsingError
        }
    }
    
    /// - Parameter jsonString: parses a json-formatted string. Throws error if it can't parse it/make it SerializedData.
    public init(jsonString: String) throws {
        if let data = (jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding) {
            try self.init(jsonData: data)
        } else {
            throw SerializedDataError.ParsingError
        }
    }
}


extension SerializedData {
//MARK: Return stored data
    
    /// - Returns: Whatever type requested, if it is possible to convert the data into that format.
    public func value<T>() -> T? {
        let formatter = NSNumberFormatter()
        switch contents {
        case .None: return nil
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
    /// - Returns: Optional(NSDate) if this object can be converted to one
    public var isNil: Bool { return contents == .None }
    
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


extension SerializedData {
//MARK: subscript and array access
    
    // SerializedData does not implement full sequence/collection type because you should be using .array and .dictionary instead (trust me, you will find it is far easier when dealing with mixed data-!).
    // But I've included append and subscript just to make editing your data a little bit easier.
    
    public subscript(index: String) -> SerializedData? {
        get {
            if case .DictionaryType(let d) = contents {
                return d[index]
            }
            return nil
        }
        set {
            if case .DictionaryType(let d) = contents {
                var newDictionary: [String: SerializedData] = d
                newDictionary[index] = newValue ?? SerializedData()
                contents = .DictionaryType(newDictionary)
            } else if case .None = contents {
                contents = .DictionaryType([index: newValue ?? SerializedData()] as [String: SerializedData])
            } else {
                assert(false, "Key does not point to dictionary-type data")
                // someday: throw SerializedDataError.TypeMismatch
            }
        }
    }
    public subscript(index: Int) -> SerializedData? {
        get {
            if case .ArrayType(let a) = contents {
                return a[index]
            }
            return nil
        }
        set {
            if case .ArrayType(let a) = contents {
                var newArray: [SerializedData] = a
                newArray.append(newValue ?? SerializedData())
                contents = .ArrayType(newArray)
            } else if case .None = contents {
                contents = .ArrayType([newValue ?? SerializedData()] as [SerializedData])
            } else {
                assert(false, "Key does not point to array-type data")
                // someday: throw SerializedDataError.TypeMismatch
            }
        }
    }
    
    /// - Parameter value: Any value type. If value cannot be converted to SerializedData, or if this SerializedData object is not an array, then it throws error. (If this object is .None, then it changes to an array of the new value.)
    public mutating func append<T>(value: T?) throws {
        guard case .ArrayType(let a) = contents else {
            throw SerializedDataError.TypeMismatch
        }
        var newArray: [SerializedData] = a
        let newValue: SerializedData = try {
            switch value {
            case let v as [SerializedData]: return SerializedData(v)
            case let v as [SerializedDataStorable?]: return SerializedData(v)
            case let v as [String: SerializedData]: return SerializedData(v)
            case let v as [String: SerializedDataStorable?]: return SerializedData(v)
            case let v as SerializedDataStorable: return SerializedData(v)
            case nil: return SerializedData()
            default: throw SerializedDataError.TypeMismatch
            }
        }()
        newArray.append(newValue)
        contents = .ArrayType(newArray)
    }
    
    /// - Returns: A dictionary if this object is one
    public var dictionary: [String: SerializedData]? {
        if case .DictionaryType(let d) = contents {
            return d
        }
        return nil
    }
    
    /// - Returns: An array if this object is one
    public var array: [SerializedData]? {
        if case .ArrayType(let a) = contents {
            return a
        }
        return nil
    }
}


extension SerializedData {
//MARK: formatting data for other uses
    
    /// - Returns: AnyObject (closest to the format used to create the SerializedData object originally)
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
        if case .None = contents {
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
        case .ValueType(_): return SerializedData.urlEncode(self.jsonString)
        case .DictionaryType(let d): return SerializedData.urlString(d)
        case .ArrayType(let a): return SerializedData.urlString(a)
        default: return ""
        }
    }
    
    /// - Parameter list: a dictionary to convert
    /// - Parameter prefix: - an optional prefix to use before the key (necessary for nested data)
    /// - Returns: A flattened String in format "key=value&key=value"
    public static func urlString(list: [String: SerializedData], prefix: String = "") -> String {
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
    public static func urlString(list: [SerializedData], prefix: String = "") -> String {
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
    public static func urlEncode(unescaped: SerializedDataStorable) -> String {
        if !(unescaped is NSNull), let escaped = "\(unescaped)".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) {
            return escaped
        }
        return ""
    }
}


//MARK: SerializedDataStorable Protocol (associations)

extension SerializedDataStorable {
    public var serializedData: String {
        get { return getData().jsonString }
    }
    public func getData() -> SerializedData {
        return SerializedData(self)
    }
}
extension SerializedDataRetrievable {
    public mutating func setData(data: SerializedData) {}
    public mutating func setData(serializedData json: String) throws {
        self.setData(try SerializedData(serializedData: json))
    }
}
//extension SerializedDataRetrievable where Self: SerializedDataStorable {
//    public var serializedData: String {
//        get { return getData().jsonString }
//        set {
//            do {
//                setData(try SerializedData(serializedData: newValue))
//            } catch {} // hopefully someday we can throw in set/get :(
//        }
//    }
//}

extension Bool: SerializedDataStorable {}
extension String: SerializedDataStorable {}
extension Int: SerializedDataStorable {}
extension Double: SerializedDataStorable {}
extension Float: SerializedDataStorable {}
// NS-stuff is nearly impossible to conform to SerializedDataRetrievable, so I am just skipping that for basic types
extension NSString: SerializedDataStorable {}
extension NSNumber: SerializedDataStorable {}
extension NSDate: SerializedDataStorable {}
extension NSNull: SerializedDataStorable {}

extension SerializedData: SerializedDataStorable {
    public func getData() -> SerializedData { return self }
}
extension SerializedData: SerializedDataRetrievable {
    public init(serializedData json: String) throws {
        try self.init(jsonString: json)
    }
    public mutating func setData(data: SerializedData) {
        contents = data.contents
    }
    public mutating func setData(serializedData json: String) throws {
        setData(try SerializedData(jsonString: json))
    }
}

// You cannot declare Array/Dictionary -both- SerializedDataStorable and containing SerializedDataStorable type (it's one or the other)
extension SequenceType where Generator.Element == (T: String, U: SerializedDataStorable?) {
    func getData() -> SerializedData {
        return SerializedData( Dictionary( map { ($0.0, SerializedData($0.1) ) } ) )
    }
}
extension SequenceType where Generator.Element == SerializedDataStorable? {
    func getData() -> SerializedData {
        return SerializedData( Array( map { SerializedData($0) } ) )
    }
}


//MARK: LiteralConvertible Protocols

extension SerializedData: NilLiteralConvertible {
	public init(nilLiteral: ()) {
    }
}
extension SerializedData: StringLiteralConvertible {
	public init(stringLiteral s: StringLiteralType) {
        contents = .ValueType(s)
	}
	public init(extendedGraphemeClusterLiteral s: StringLiteralType) {
        contents = .ValueType(s)
	}
	public init(unicodeScalarLiteral s: StringLiteralType) {
        contents = .ValueType(s)
	}
}
extension SerializedData: IntegerLiteralConvertible {
	public init(integerLiteral i: IntegerLiteralType) {
        contents = .ValueType(i)
	}
}
extension SerializedData: FloatLiteralConvertible {
	public init(floatLiteral f: FloatLiteralType) {
        contents = .ValueType(f)
	}
}
extension SerializedData: BooleanLiteralConvertible {
	public init(booleanLiteral b: BooleanLiteralType) {
        contents = .ValueType(b)
	}
}
extension SerializedData:  DictionaryLiteralConvertible {
    public typealias Key = String
    public typealias Value = SerializedDataStorable
	public init(dictionaryLiteral tuples: (Key, Value)...) {
        contents = .DictionaryType(Dictionary(tuples.map { ($0.0, $0.1.getData()) }))
	}
	public init(dictionaryLiteral tuples: (Key, Value?)...) {
        contents = .DictionaryType(Dictionary(tuples.map { ($0.0, $0.1?.getData()  ?? SerializedData()) }))
	}
}
extension SerializedData:  ArrayLiteralConvertible {
    public typealias Element = SerializedDataStorable
	public init(arrayLiteral elements: Element...) {
        contents = .ArrayType(elements.map { $0.getData() })
	}
	public init(arrayLiteral elements: Element?...) {
        contents = .ArrayType(elements.map { $0?.getData() ?? SerializedData() })
	}
}


extension SerializedData: Equatable {}
//MARK: - Equatable Protocol

public func ==(lhs: SerializedData, rhs: SerializedData) -> Bool {
    return lhs.contents == rhs.contents
}
public func ==(lhs: SerializedData?, rhs: SerializedData?) -> Bool {
    return lhs?.contents ?? .None == rhs?.contents ?? .None
}
public func ==(lhs: SerializedData, rhs: SerializedData?) -> Bool {
    return lhs.contents == rhs?.contents ?? .None
}
public func ==(lhs: SerializedData?, rhs: SerializedData) -> Bool {
    return lhs?.contents ?? .None == rhs.contents
}

extension SerializedData.StorageType: Equatable {}

func == (lhs: SerializedData.StorageType, rhs: SerializedData.StorageType) -> Bool {
    switch (lhs, rhs) {
    case (.None, .None):
        return true
    case (.ValueType(let v1), .ValueType(let v2)):
        // do we care about type? I don't think so...
        return "\(v1)" == "\(v2)"
    case (.DictionaryType(let v1), .DictionaryType(let v2)):
        return v1 == v2
    case (.ArrayType(let v1), .ArrayType(let v2)):
        return v1 == v2
    default: return false
    }
}

//extension SerializedDataStorable: Equatable {}
// we can't declare SerializedDataStorable Equatable or ArrayLiteralConvertible and DictionaryLiteralConvertible break, also would have to be declared on SerializedDataStorable initial definition
// also, since SerializedData is SerializedDataStorable, there is infinite looping. :(
//public func ==(lhs: SerializedDataStorable?, rhs: SerializedDataStorable?) -> Bool {
//    print("X")
//    return (lhs?.getData() ?? nil) == (rhs?.getData() ?? nil)
//}


extension SerializedData: CustomStringConvertible {
//MARK: - CustomStringConvertible Protocol

    public var description: String {
        switch contents {
        case .ValueType(let s): return "\(s)"
        case .DictionaryType(let d):
            var description = ""
            for (key, value) in d {
                description += "\(key)=\(value.description),"
            }
            return !description.isEmpty ? "[\(description.stringFrom(0, to: -1))]" : "[]"
        case .ArrayType(let a):
            var description = ""
            for (value) in a {
                description += "\(value.description),"
            }
            return !description.isEmpty ? "[\(description.stringFrom(0, to: -1))]" : "[]"
        default: return "nil"
        }
    }
}

