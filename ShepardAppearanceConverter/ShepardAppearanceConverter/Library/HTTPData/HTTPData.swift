//
//  HTTPData.swift
//
//  Created by Emily Ivie on 4/1/15.
//

import Foundation

/**
    Stores a json-style data array of values, arrays, and dictionaries. Accepts almost any kind of list data, but it works better if you state what kind of list it is upfront, like: init(["some"] as [String]).

    You can use two generic types of data: 
    Any? (all values including structs and optionals/nil) or,
    AnyObject (values convertible to Objective-C objects)

    - HTTPData(simpleValue)
    - HTTPData([String: values]) and HTTPData([values]) and even HTTPData([HTTPData])
    - HTTPData(jsonData: myNSDataThatIsJSON) //parses it for you
    - HTTPData(jsonString: myStringThatIsJSON) //parses it for you
    - To access a value (returns optionals):
        let myValue = myData.string
    - To test for nil:
        myData.isNil
    - To iterate through an array (returns [HTTPData]):
        if myData.isArray { for value in myData.array {} }
    - To iterate through a dictionary (returns [String: HTTPData]):
        if myData.isDictionary { for (key, value) in myData.dictionary {} }
    - To get a JSON string back
        myData.jsonString
    - To get form data string or url query string back:
        myData.urlString
    - To get an objective-c array or dictionary (for NSUserDefaults or such)
        myData.objcValue()

    There are convenience equatables and comparables, so you can also do the following:

    - myData["someKey"] == "someKeyValue"
    - myData["someKey"] > 5

    Comparing two HTTPData values compares them as String. Comparing nil, array, or dictionary will return false.
*/
public struct HTTPData {
    
    /**
        Stores anything from a value to a series of embedded dictionaries. 
        Since all subscript access returns an HTTPData object, we can chain access without error:
            myData["prop1"]["prop2"]["prop3"]
    */
    internal var contents = DataType.Null
    
    //MARK: initialization
    
    public init(jsonData: NSData){
        do {
            let response: AnyObject? = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
            if let r = response as? [String: AnyObject] {
                initFromDictionary(r)
                return
            } else if let r = response as? [AnyObject] {
                initFromArray(r)
                return
            }
        } catch {
            return
        }
    }
    
    public init(jsonString: String) {
        if let data = (jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding) {
            let h = HTTPData(jsonData: data)
            contents = h.contents
        }
    }

    public init(_ data: Any?){
        // arranged from most to least specific type
        // bottom level value type must be convertible to AnyObject and then convertible to String/Nil
        
        if let d = data as? [String: HTTPData] {
            contents = .DictionaryType(d)
            return
        } else if let a = data as? [HTTPData] {
            contents = .ArrayType(a)
            return
        } else if let h = data as? HTTPData {
            contents = h.contents
            return
        } else if let anyObjectData: AnyObject = data as? AnyObject {
             if let d = anyObjectData as? [String: AnyObject] {
                initFromDictionary(d)
                return
            } else if let a = anyObjectData as? [AnyObject] {
                initFromArray(a)
                return
//            } else if let d = anyObjectData as? [String: Any?] {
//                initFromDictionary(anyData: d)
//            } else if let a = anyObjectData as? [Any?] {
//                initFromArray(anyData: a)
            }
        }
        if let d = data as? [String: Any?] {
            initFromDictionary(anyData: d)
            return
        } else if let a = data as? [Any?] {
            initFromArray(anyData: a)
            return
        } else if let d = getSpecificOptionalDictionary(data) {
            // some specific optional dictionaries like [String: String?] are not picked up by prior conversions
            initFromDictionary(anyData: d)
            return
        } else if let a = getSpecificOptionalArray(data) {
            // some specific optional arrays like [String?] are not picked up by prior conversions
            initFromArray(anyData: a)
            return
        }
        contents = dataType(data as? AnyObject)
    }
    
    public init(){} //nil
    
    private mutating func initFromDictionary(data: [String: AnyObject]){ //preferred
        var dataList = [String: HTTPData]()
        for (key, value) in data {
            dataList[key] = HTTPData(value)
        }
        contents = .DictionaryType(dataList)
    }
    private mutating func initFromDictionary(anyData data: [String: Any?]){ //allowed
        var dataList = [String: HTTPData]()
        for (key, value) in data {
            dataList[key] = HTTPData(value)
        }
        contents = .DictionaryType(dataList)
    }
    
    private mutating func initFromArray(data: [AnyObject]){ //preferred
        var dataList = [HTTPData]()
        for value in data {
            dataList.append(HTTPData(value))
        }
        contents = .ArrayType(dataList)
    }
    
    private mutating func initFromArray(anyData data: [Any?]){ //allowed
        var dataList = [HTTPData]()
        for value in data {
            dataList.append(HTTPData(value))
        }
        contents = .ArrayType(dataList)
    }
    
    //MARK: DataType definition
    
    /**
        Holds a variety of HTTPData types, like strings, arrays, and dictionaries.
        This allows me to create a strictly-defined data type that holds multiple types of allowed data.
        May someday expand to allow files.
    */
    internal enum DataType {
        case Null
        case StringType(String)
        case DictionaryType([String: HTTPData])
        case ArrayType([HTTPData])
        
        internal func isNull() -> Bool {
            switch self {
            case .Null: return true
            default: return false
            }
        }
        internal func isString() -> Bool {
            switch self {
            case .StringType(_): return true
            default: return false
            }
        }
        internal func isDictionary() -> Bool {
            switch self {
            case .DictionaryType(_): return true
            default: return false
            }
        }
        internal func isArray() -> Bool {
            switch self {
            case .ArrayType(_): return true
            default: return false
            }
        }
    }

    /**
        Accepts a variety of HTTPData types, like strings, arrays, and dictionaries.
        Used by HTTPData init to store data coming in.
        May someday expand to allow files.
        
        :param: value   Data of AnyObject? like that returned by internal json parser
        :returns: data converted to HTTPData.DataType, all standardized for storage
    */
    private mutating func dataType(value: AnyObject?) -> DataType {
        switch value {
        case is NSNull: fallthrough
        case nil: return .Null
        case is String: fallthrough
        case is Bool: fallthrough
        case is Int: fallthrough
        case is Double: fallthrough
        case is Float: return .StringType("\(value!)")
        case is NSDate:
            if let date = value as? NSDate {
                if let dateString = stringFromDate(date) {
                    return .StringType(dateString)
                }
            }
            fallthrough
        default:
            break
        }
        return .Null
    }
    
    private mutating func getSpecificOptionalDictionary(data: Any?) -> [String: Any?]? {
        var genericDictionary: [String: Any?]?
        func mapDictionary<Value>(data: [String: Value]?) -> [String: Any?]? {
            var genericDictionary: [String: Any?]!
            if data != nil {
                genericDictionary = [:]
                data!.map { genericDictionary[$0.0] = $0.1 }
            }
            return genericDictionary
        }
        if let d = data as? [String: String?] {
            genericDictionary = mapDictionary(d)
        } else if let d = data as? [String: Int?] {
            genericDictionary = mapDictionary(d)
        } else if let d = data as? [String: Double?] {
            genericDictionary = mapDictionary(d)
        } else if let d = data as? [String: Float?] {
            genericDictionary = mapDictionary(d)
        } else if let d = data as? [String: Bool?] {
            genericDictionary = mapDictionary(d)
        }
        return genericDictionary
    }

    private mutating func getSpecificOptionalArray(data: Any?) -> [Any?]? {
        var genericArray: [Any?]?
        func mapArray<Value>(data: [Value]?) -> [Any?]? {
            var genericArray: [Any?]!
            if data != nil {
                genericArray = []
                data!.map { genericArray.append($0) }
            }
            return genericArray
        }
        if let d = data as? [String?] {
            genericArray = mapArray(d)
        } else if let d = data as? [Int?] {
            genericArray = mapArray(d)
        } else if let d = data as? [Double?] {
            genericArray = mapArray(d)
        } else if let d = data as? [Float?] {
            genericArray = mapArray(d)
        } else if let d = data as? [Bool?] {
            genericArray = mapArray(d)
        }
        return genericArray
    }
    
    //MARK: Introspection features
    
    /**
        Converts any HTTPData object to its whatever-Literal format, nil if it can't convert to the requested format.
        Use this for looking up values from the data.
        Example: let x = jsonData["testVal1"].value() as Float?
    
        :returns: an optional value of whatever type requested
    */
    public func value<T>() -> T? {
        let formatter = NSNumberFormatter()
        switch contents {
        case .Null: return nil
        case .StringType(let value):
            if let tValue = value as? T {
                return tValue
            } else if let tValue = NSString(string: value).boolValue as? T {
                return tValue
            } else if let tValue = formatter.numberFromString(value)?.integerValue as? T {
                return tValue
            } else if let tValue = formatter.numberFromString(value)?.floatValue as? T {
                return tValue
            } else if let tValue = formatter.numberFromString(value)?.doubleValue as? T {
                return tValue
            } else if let tValue = dateFromString(value) as? T {
                return tValue
            } else if let tValue = formatter.numberFromString(value) as? T { //NSNumber
                return tValue
            } else {
                return nil
            }
        case .DictionaryType(let value):
            if let tValue = value as? T {
                return tValue
            } else {
                return nil
            }
        case .ArrayType(let value):
            if let tValue = value as? T {
                return tValue
            } else {
                return nil
            }
        }
    }
    
    /**
        Converts strings to dates
    
        :param: value       a string date in YYYY-MM-dd HH:mm:ss format and GMT timezone
        :returns: optional date
    */
    private func dateFromString(value: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        //add more flexible parsing later
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let date = dateFormatter.dateFromString(value)
        return date
    }
    
    
    /**
        Converts dates to strings
    
        :param: value       a date
        :returns: optional string date in YYYY-MM-dd HH:mm:ss format and GMT timezone
    */
    private func stringFromDate(value: NSDate) -> String? {
        let dateFormatter = NSDateFormatter()
        //add more flexible parsing later
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        return dateFormatter.stringFromDate(value)
    }
    
    /**
        Convenience way to get dictionary
            
        :returns: the dictionary value or an empty dictionary
    */
    public var dictionary: [String: HTTPData] {
        switch contents {
        case .DictionaryType(let d): return d
        default: return [:]
        }
    }
    
    /**
        Convenience way to get array
            
        :returns: the array value or an empty array
    */
    public var array: [HTTPData] {
        switch contents {
        case .ArrayType(let a): return a
        default: return []
        }
    }
    
    /**
        Convenience way to get value
            
        :returns: an optional string
    */
    public var string: String? {
        return value() as String?
    }
    
    /**
        Convenience way to get value
            
        :returns: an optional bool
    */
    public var bool: Bool? {
        return value() as Bool?
    }
    
    /**
        Convenience way to get value
            
        :returns: an optional int
    */
    public var int: Int? {
        return value() as Int?
    }
    
    /**
        Convenience way to get value
            
        :returns: an optional float
    */
    public var float: Float? {
        return value() as Float?
    }
    
    /**
        Convenience way to get value
            
        :returns: an optional double
    */
    public var double: Double? {
        return value() as Double?
    }
    
    /**
        Convenience way to get value
            
        :returns: an optional NSNumber
    */
    public var nsNumber: NSNumber? {
        return value() as NSNumber?
    }
    
    /**
        Convenience way to get value
            
        :returns: an optional nsdate
    */
    public var date: NSDate? {
        return value() as NSDate?
    }
    
    /**
        :returns: true is this HTTPData is a dictionary
    */
    public var isDictionary: Bool {
        switch contents {
        case .DictionaryType: return true
        default: return false
        }
    }
    
    /**
        :returns: true is this HTTPData is an array
    */
    public var isArray: Bool {
        switch contents {
        case .ArrayType: return true
        default: return false
        }
    }
    
    /**
        :returns: true is this HTTPData is a null value
    */
    public var isNil: Bool {
        switch contents {
        case .Null: return true
        default: return false
        }
    }
}

// MARK: LiteralConvertibles (for Setters)

extension HTTPData: NilLiteralConvertible,
                    StringLiteralConvertible, 
                    IntegerLiteralConvertible,
                    FloatLiteralConvertible,
                    //Double???
                    BooleanLiteralConvertible,
                    //Date???
                    DictionaryLiteralConvertible,
                    ArrayLiteralConvertible {
    
	public init(nilLiteral: ()) {}
    
	public init(stringLiteral s: StringLiteralType) {
        contents = dataType(s)
	}
	public init(extendedGraphemeClusterLiteral s: StringLiteralType) {
        contents = dataType(s)
	}
	public init(unicodeScalarLiteral s: StringLiteralType) {
        contents = dataType(s)
	}
    
	public init(integerLiteral i: IntegerLiteralType) {
        contents = dataType(i)
	}
    
	public init(floatLiteral f: FloatLiteralType) {
        contents = dataType(f)
	}
    
	public init(booleanLiteral b: BooleanLiteralType) {
        contents = dataType(b)
	}
    
	public init(dictionaryLiteral tuples: (String, Any?)...) {
        var d = [String: Any?]()
        tuples.map { (k,v) in d[k] = v }
        contents = HTTPData(d).contents
	}
    
	public init(arrayLiteral a: Any?...) {
        contents = HTTPData(a).contents
	}
}


extension HTTPData {
    //MARK: subscript
    
    /**
        Always returns an HTTPData object so we can chain access without error:
            myData["prop1"]["prop2"]["prop3"]
            
        :param: index   The dictionary key or array index to return
        :returns: the next level of HTTPData
    */
    public subscript(index: String) -> HTTPData {
        get {
            var data:HTTPData?
            switch contents {
            case .DictionaryType(let d): data = d[index]
            default: break
            }
            return data ?? HTTPData()
        }
        set {
            switch contents {
            case .DictionaryType(var d):
                d[index] = newValue
                contents = .DictionaryType(d)
//            case .Null(): // allows creation of dictionary on empty HTTPData
//                contents = .DictionaryType([index: newValue])
            default:
                assert(false, "Only valid for dictionary-type data")
                break
            }
        }
    }
    /**
        Always returns an HTTPData object so we can chain access without error:
            myData["prop1"]["prop2"]["prop3"]
            
        :param: index   The dictionary key or array index to return
        :returns: the next level of HTTPData
    */
    public subscript(index: Int) -> HTTPData {
        get {
            var data:HTTPData?
            switch contents {
            case .ArrayType(let a): data = a[index]
            default: break
            }
            return data ?? HTTPData()
        }
        set {
            switch contents {
            case .ArrayType(var a):
                if index >= a.count {
                    a.append(newValue)
                } else {
                    a[index] = newValue
                }
                contents = .ArrayType(a)
            default:
                assert(false, "Only valid for array-type data")
                break
            }
        }
    }
    
    /**
        Convenience way to append to array type data
            
        :param: newValue   The new data to insert
    */
    public mutating func append(newValue: Any?){
        switch contents {
        case .ArrayType(var a):
            let newData: HTTPData!
            if let x = newValue as? HTTPData {
                newData = x
            } else {
                newData = HTTPData(newValue)
            }
            a.append(newData)
            contents = .ArrayType(a)
        default:
            assert(false, "Only valid for array-type data")
            break
        }
    }
    
    /**
        Convenience way to get count
            
        :returns: the array or dictionary count or 0
    */
    public var count: Int {
        switch contents {
        case .DictionaryType(var d): return d.count
        case .ArrayType(var a): return a.count
        default: return 0
        }
    }
}

extension HTTPData {
    
    //MARK: data
    
    /**
        :returns: An objective-c object (closest to the NSDictionary/NSArray used to create the HTTPData object originally)
    */
    var objcValue: AnyObject {
        switch self.contents {
        case .StringType(let s):
            return s as NSString
        case .DictionaryType(let d):
            let list = NSMutableDictionary()
            for (key, value) in d {
                list[key] = value.objcValue
            }
            return list
        case .ArrayType(let a):
            let list = NSMutableArray()
            for (value) in a {
                list.addObject(value.objcValue)
            }
            return list
        default:
            return NSNull()
        }
    }

    /**
        :returns: An NSData object (closest value to the data used to create the HTTPData object originally)
    */
    var data: NSData? {
        if isNil {
            // can't make a json object with *just* nil (NSNull inside array/dictionary is okay)
            return nil
        }
        do {
            let data: NSData? = try NSJSONSerialization.dataWithJSONObject(objcValue, options: NSJSONWritingOptions.PrettyPrinted)
            return data
        } catch {
            return nil
        }
    }
    
    //MARK: jsonString
    
    /**
        Returns data as json text
    
        :returns:           A flattened String
    */
    public var jsonString: String {
        switch contents {
        case .StringType(let s): return s
        case .DictionaryType(_): fallthrough
        case .ArrayType(_):
            if let d = data, let jsonString = NSString(data: d, encoding: NSUTF8StringEncoding) as? String {
                return jsonString
            }
            fallthrough
        default: return ""
        }
    }

    //MARK: urlString
    
    /**
        Returns data as a string of format "key=value&key=value"
    
        :returns:           A flattened String in format "key=value&key=value"
    */
    public var urlString: String {
        switch contents {
        case .StringType(let s): return s
        case .DictionaryType(let d): return HTTPData.urlString(d)
        case .ArrayType(let a): return HTTPData.urlString(a)
        default: return ""
        }
    }
    
    /**
        A utility to turn data into a string of format "key=value&key=value"
    
        :param: list        A Dictionary of [String: DataType] or Array of [DataType]
        :returns:           A flattened String in format "key=value&key=value"
    */
    static func urlString(list: [String: HTTPData], prefix: String = "") -> String {
        var urlString = String("")
        for (key, value) in list {
            let prefixedKey = prefix != "" ? "\(prefix)[\(key)]" : key
            switch value.contents {
            case .StringType(let s): urlString += "\(self.urlEncode(prefixedKey))=\(self.urlEncode(s))&"
            case .DictionaryType(let d): urlString += "\(self.urlString(d, prefix: prefixedKey))&"
            case .ArrayType(let a): urlString += "\(self.urlString(a, prefix: prefixedKey))&"
            default: urlString += "\(self.urlEncode(prefixedKey))=&"
            }
        }
        return urlString.isEmpty ? "" : urlString.stringFrom(0, to: -1)
    }
    
    /**
        A utility to turn data into a string of format "key=value&key=value"
    
        :param: list        A Dictionary of [String: DataType] or Array of [DataType]
        :returns:           A flattened String in format "key=value&key=value"
    */
    static func urlString(list: [HTTPData], prefix: String = "") -> String {
        var urlString = String("")
        for (value) in list {
            let prefixedKey = prefix != "" ? "\(prefix)[]" : ""
            let prefixHere = prefixedKey != "" ? "\(self.urlEncode(prefixedKey))=" : ""
            switch value.contents {
            case .StringType(let s): urlString += prefixHere + self.urlEncode(s) + "&"
            case .DictionaryType(let d): urlString += "\(self.urlString(d, prefix: prefixedKey))&"
            case .ArrayType(let a): urlString += "\(self.urlString(a, prefix: prefixedKey))&"
            default: urlString += prefixHere + ","
            }
        }
        return urlString.isEmpty ? "" : urlString.stringFrom(0, to: -1)
    }

    /**
        A utility to escape data for inclusion in url query strings and such.
    
        :param: unescaped   The unescaped String
        :returns:           The escaped String (or unescaped, if there was an error)
    */
    static func urlEncode(unescaped: String!) -> String {
        if unescaped != nil, let escaped = unescaped.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) {
            return escaped
        }
        return ""
    }
}



extension HTTPData: CustomStringConvertible {
    // MARK: - Printable
    public var description: String {
//        return "\(objcValue)"
        switch contents {
        case .StringType(let s): return "\(s)"
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



extension HTTPData: Equatable {
    // MARK: - Equatable
    /**
        Convenience function to compare an HTTPData value with another value. Used by Equatable protocol functions.
        Can compare any simple type from value(): String, Int, Float, Double (... not Dictionaries and Arrays)
        Example: jsonData["testVal1"] == "12345"
    
        :param: rhs     The value to be compared to, of any Equatable type
        :returns: false if could not convert both items to the same type, otherwise the comparison result
    */
    public func equateTo<T:Equatable>(rhs: T) -> Bool {
        if rhs is HTTPData {
            return description == "\(rhs)"
        }
        let lhs = value() as T?
        return lhs != nil ? lhs == rhs : false
    }
    
}
// Equatable Protocol:
public func ==<T:Equatable>(lhs: HTTPData, rhs: T) -> Bool {
    return lhs.equateTo(rhs)
}
public func ==<T:Equatable>(lhs: T, rhs: HTTPData) -> Bool {
    return rhs.equateTo(lhs)
}
public func ==(lhs: HTTPData, rhs: HTTPData) -> Bool {
    return lhs.equateTo(rhs)
}


extension HTTPData: Comparable {
    // MARK: - Comparable
    /**
        Convenience function to compare an HTTPData value with another value. Used by Comparable protocol functions.
        Can compare any simple type from value(): String, Int, Float, Double (... not Dictionaries and Arrays).
        Example: jsonData["testVal1"] >= 12345
        Note: Comparing 2 HTTPData types will use String comparison, because I don't know what you want. 
            If you want a numeric comparison, you must convert one of them to a number first.
    
        :param: rhs             The value to be compared to, of any Comparable type
        :param: compareUsing    A string of the comparison operator "<" ">" "<=" ">="
        :returns: false if could not convert both items to the same type, otherwise the comparison result
    */
    public func compareTo<T:Comparable>(rhs: T, compareUsing: String) -> Bool  {
        if rhs is HTTPData {
            switch compareUsing{
            case ">": return description > "\(rhs)"
            case "<": return description < "\(rhs)"
            case ">=": return description >= "\(rhs)"
            case "<=": return description <= "\(rhs)"
            default: return false
            }
        }
        let lhs = value() as T?
        if lhs == nil { return false }
        switch compareUsing{
        case ">": return lhs! > rhs
        case "<": return lhs! < rhs
        case ">=": return lhs! >= rhs
        case "<=": return lhs! <= rhs
        default: return false
        }
    }
}
// Comparable Protocol:
public func >(lhs: HTTPData, rhs: HTTPData) -> Bool {
    return lhs.compareTo(rhs, compareUsing: ">")
}
public func ><T:Comparable>(lhs: HTTPData, rhs: T) -> Bool {
    return lhs.compareTo(rhs, compareUsing: ">")
}
public func ><T:Comparable>(lhs: T, rhs: HTTPData) -> Bool {
    return rhs.compareTo(lhs, compareUsing: "<") //swap
}
public func <(lhs: HTTPData, rhs: HTTPData) -> Bool {
    return lhs.compareTo(rhs, compareUsing: "<")
}
public func <<T:Comparable>(lhs: HTTPData, rhs: T) -> Bool {
    return lhs.compareTo(rhs, compareUsing: "<")
}
public func <<T:Comparable>(lhs: T, rhs: HTTPData) -> Bool {
    return rhs.compareTo(lhs, compareUsing: ">") //swap
}
public func >=(lhs: HTTPData, rhs: HTTPData) -> Bool {
    return lhs.compareTo(rhs, compareUsing: ">=")
}
public func >=<T:Comparable>(lhs: HTTPData, rhs: T) -> Bool {
    return lhs.compareTo(rhs, compareUsing: ">=")
}
public func >=<T:Comparable>(lhs: T, rhs: HTTPData) -> Bool {
    return rhs.compareTo(lhs, compareUsing: "<=") //swap
}
public func <=(lhs: HTTPData, rhs: HTTPData) -> Bool {
    return lhs.compareTo(rhs, compareUsing: "<=")
}
public func <=<T:Comparable>(lhs: HTTPData, rhs: T) -> Bool {
    return lhs.compareTo(rhs, compareUsing: "<=")
}
public func <=<T:Comparable>(lhs: T, rhs: HTTPData) -> Bool {
    return rhs.compareTo(lhs, compareUsing: ">=") //swap
}

