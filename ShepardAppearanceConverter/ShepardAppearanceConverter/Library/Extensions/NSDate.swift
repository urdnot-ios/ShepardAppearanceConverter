//
//  NSDate.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/12/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import Foundation

extension NSDate {
    
    private static var sharedFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        return formatter
    }()
    
    private func formatStandardStyle(dateStyle: NSDateFormatterStyle = .LongStyle, _ timeStyle: NSDateFormatterStyle = .LongStyle) -> String? {
        NSDate.sharedFormatter.dateStyle = dateStyle
        NSDate.sharedFormatter.timeStyle = timeStyle
        return NSDate.sharedFormatter.stringFromDate(self)
    }
    
    private func formatCustomString(format: String = "MMMMd") -> String? {
        NSDate.sharedFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate(format, options: 0, locale: nil)
        let dateString = NSDate.sharedFormatter.stringFromDate(self)
        NSDate.sharedFormatter.dateFormat = nil //cleanup
        return dateString
    }
    
    public func format(format: DateFormat) -> String? {
        switch format {
        case .Typical: return self.formatStandardStyle(.ShortStyle, .ShortStyle)
        }
    }
}

public enum DateFormat {
    case Typical
}
