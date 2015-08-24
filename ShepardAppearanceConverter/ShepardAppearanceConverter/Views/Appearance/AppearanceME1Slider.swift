//
//  AppearanceME1Slider.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/23/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

public class AppearanceME1Slider: UIStackView {
    
    public lazy var headerStack: UIStackView! = {
        return self.arrangedSubviews.first as? UIStackView
    }()
    
    public lazy var valueStack: UIStackView! = {
        return self.headerStack.arrangedSubviews.last as? UIStackView
    }()

    public lazy var titleLabel: UILabel! = {
        if let wrapper = self.headerStack?.arrangedSubviews.first {
            return wrapper.subviews.first as? UILabel
        }
        return nil
    }()
    
    public lazy var valueLabel: UILabel! = {
        return self.valueStack?.arrangedSubviews.last as? UILabel
    }()
    
    public lazy var valueSlider: UISlider! = {
        return self.valueStack?.arrangedSubviews.first as? UISlider
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
    
    
    // stack orientation by size classes still buggy in iOS 9. This hack corrects it. :(
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        configureViewForSizeClass()
    }
    
    var lastHorizontalSizeClass: UIUserInterfaceSizeClass?

    private func configureViewForSizeClass() {
        if lastHorizontalSizeClass != .Regular && traitCollection.horizontalSizeClass == .Regular {
            headerStack.axis = .Horizontal
            lastHorizontalSizeClass = .Regular
        } else if lastHorizontalSizeClass != .Compact && traitCollection.horizontalSizeClass == .Compact {
            headerStack.axis = .Vertical
            lastHorizontalSizeClass = .Compact
        }
    }
}
