//
//  UIImage.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 9/3/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

extension UIImage {
    
    public convenience init?(documentsFileName fileName: String) {
        if let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]).first {
            self.init(contentsOfFile: documentsDirectory.stringByAppendingPathComponent(fileName))
        } else {
            return nil
        }
    }
    
    public func save(documentsFileName fileName: String) -> Bool {
        if let imageData = UIImagePNGRepresentation(self),
           let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]).first {
            imageData.writeToFile(documentsDirectory.stringByAppendingPathComponent(fileName), atomically: true)
            return true
        }
        return false
    }
}