//
//  ShepardAppearanceME1Group.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/23/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

public class ShepardAppearanceME1Group: UIView {

    public lazy var titleLabel: UILabel! = {
        for view in self.subviews where view is UILabel {
            return view as? UILabel
        }
        return nil
    }()
    
    public lazy var slidersStack: UIStackView! = {
        for view in self.subviews where view is UIStackView {
            return view as? UIStackView
        }
        return nil
    }()

}
