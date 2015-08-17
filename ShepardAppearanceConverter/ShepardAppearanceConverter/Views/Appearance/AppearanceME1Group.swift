//
//  AppearanceME1Group.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/9/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

public class AppearanceME1Group: FauxContentRow {

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

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
