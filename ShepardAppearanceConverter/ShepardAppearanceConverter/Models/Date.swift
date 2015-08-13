//
//  Date.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/12/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

public class Date {
    
    private static var formatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        return formatter
    }()
    
    private class func formatStandard(date: NSDate!, styles: (NSDateFormatterStyle, NSDateFormatterStyle) = (NSDateFormatterStyle.LongStyle, NSDateFormatterStyle.LongStyle)) -> String? {
        formatter.dateStyle = styles.0
        formatter.timeStyle = styles.1
        return formatter.stringFromDate(date)
    }
    
    private class func formatCustom(date: NSDate!, format: String = "MMMMd") -> String? {
        if date == nil {
            return nil
        }
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate(format, options: 0, locale: nil)
        let dateString = formatter.stringFromDate(date)
        formatter.dateFormat = nil //cleanup
        return dateString
    }
    
    public class func format(date: NSDate!, format: DateFormat = .Typical) -> String? {
        switch format {
        case .Typical: return self.formatStandard(date, styles: (NSDateFormatterStyle.ShortStyle, NSDateFormatterStyle.ShortStyle))
        }
    }
}

public enum DateFormat {
    case Typical
}
