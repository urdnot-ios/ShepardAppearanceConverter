//
//  AppearanceME1Slider.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/23/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

public class AppearanceME1Slider: UIStackView {
    
    public lazy var valueStack: UIView! = {
        for view in self.subviews {
            return view
        }
        return nil
    }()

    public lazy var titleLabel: UILabel! = {
        let subviews: [UIView] = self.valueStack?.subviews ?? []
        for view in subviews where view is UILabel {
            return view as? UILabel
        }
        return nil
    }()
    
    public lazy var valueLabel: UILabel! = {
        var count = 0
        let subviews: [UIView] = self.valueStack?.subviews ?? []
        for view in subviews where view is UILabel {
            if count++ < 1 { continue }
            return view as? UILabel
        }
        return nil
    }()
    
    public lazy var valueSlider: UISlider! = {
        let subviews: [UIView] = self.valueStack?.subviews ?? []
        for view in subviews where view is UISlider {
            return view as? UISlider
        }
        return nil
    }()
    
    public lazy var noticeLabel: UILabel! = {
        for view in self.subviews where view is UILabel {
            return view as? UILabel
        }
        return nil
    }()
    
    public lazy var alertLabel: UILabel! = {
        var count = 0
        for view in self.subviews where view is UILabel {
            if count++ < 1 { continue }
            return view as? UILabel
        }
        return nil
    }()

}
