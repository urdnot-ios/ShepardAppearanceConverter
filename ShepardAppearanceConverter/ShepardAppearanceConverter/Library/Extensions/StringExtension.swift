//
//  StringExtension.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/25/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import Foundation

extension String {
    func intIndexOf(searchC: Character) -> Int? {
        var i = 0
        for foundC in self.characters {
            if searchC == foundC { return i }
            i++
        }
        return nil
    }
    /**
        Pads the left side of a string with the specified string up to the specified length.
        Does not clip the string if too long.
    
        :param: padding   The string to use to create the padding (if needed)
        :param: length    Integer target length for entire string
        :returns: The padded string
    */
    func lpad(padding: String, length: Int) -> (String) {
        if characters.count > length {
            return self
        }
        return "".stringByPaddingToLength(length - characters.count, withString:padding, startingAtIndex:0) + self
    }
    /**
        Pads the right side of a string with the specified string up to the specified length.
        Does not clip the string if too long.
    
        :param: padding   The string to use to create the padding (if needed)
        :param: length    Integer target length for entire string
        :returns: The padded string
    */
    func rpad(padding: String, length: Int) -> (String) {
        if characters.count > length { return self }
        return self.stringByPaddingToLength(length, withString:padding, startingAtIndex:0)
    }
    /**
        Returns string with left and right spaces trimmed off.
    
        :returns: Trimmed String
    */
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    /**
        Shortcut for getting length (since Swift keeps cahnging this).
    
        :returns: Int length of string
    */
    var length: Int {
        return characters.count
    }
    /**
        Returns character at a specific position from a string.
        
        :param: index               The position of the character
        :returns: Character
    */
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    /**
        Returns substring extracted from a string at start and end location.
    
        :param: start               Where to start (-1 acceptable)
        :param: end                 (Optional) Where to end (-1 acceptable) - default to end of string
        :returns: String
    */
    func stringFrom(start: Int, to end: Int? = nil) -> String {
        var maximum = characters.count
        let startIndex = advance(start < 0 ? self.endIndex : self.startIndex, min(maximum, max(-1 * maximum, start)))
        maximum -= start
        let endIndex = end != nil && end! < characters.count ? advance(end < 0 ? self.endIndex : self.startIndex, min(maximum, max(-1 * maximum, end!))) : self.endIndex
        return self.substringWithRange(Range(start: startIndex, end: endIndex))
    }
    /**
        Returns substring composed of only the allowed characters.
    
        :param: allowed             String list of acceptable characters
        :returns: String
    */
    func onlyCharacters(allowed: String) -> String {
        let search = allowed.characters
        return characters.filter({ search.contains($0) }).reduce("", combine: { $0 + String($1) })
    }
    /**
        Simple pattern matcher. Requires full match (ie, includes ^$ implicitly).
        
        :param: pattern             Regex pattern (includes ^$ implicitly)
        :returns: true if full match found
    */
    func matches(pattern: String) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", pattern)
        return test.evaluateWithObject(self)
    }
    /**
        Replaces a string with another string
        
        :param: find                The string to search for
        :param: replace             The string to replace with
        :returns: new string
    */
    func replace(find: String, _ replace: String) -> String {
        var string = self
        if let range = string.rangeOfString(find) {
            string.replaceRange(range, with: replace)
        }
        return string
    }
}