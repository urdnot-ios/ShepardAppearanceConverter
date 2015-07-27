//
//  ShepardAppearanceConverterController.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/18/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit


class ShepardAppearanceConverterController: UIViewController, UITextFieldDelegate {

    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var ME23GameSegment: UISegmentedControl!
    @IBOutlet weak var ME2CodeField: UITextField!
    @IBOutlet weak var ME2CodeLabel: UILabel!
    @IBOutlet weak var ME2NoticeLabel: UILabel!
    @IBOutlet weak var ME2AlertLabel: UILabel!
    
    @IBOutlet weak var ME1GenderSegment: UISegmentedControl!
    @IBOutlet weak var ME1Wrapper: UIView!
    @IBOutlet weak var ME1GroupsList: UIStackView!
    @IBOutlet weak var ME1Group: ShepardAppearanceME1Group!
    @IBOutlet weak var ME1Slider: ShepardAppearanceME1Slider!
    
    @IBOutlet weak var notesLabel1: UILabel!
    @IBOutlet weak var notesLabel2: UILabel!
    
    let ConvertAlert = "This conversion may be flawed. See more notes on the sliders below."
    let ConvertNotice = "This conversion is approximate. See more notes on the sliders below."
    
    var gender = Shepard.Gender.Male
    var game23 = Shepard.Game.Game2
    
    lazy var spinner: Spinner = {
        return Spinner(parent: self)
    }()
    
    //MARK: Page Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.start()
        setupGame23Fields()
        setupGame1Fields()
        ME1GenderSegment.selectedSegmentIndex = gender == .Male ? 0 : 1
        restrictSlidersToGender(gender)
        spinner.stop()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    //MARK: @IBActions
    
    private var lastCode: String?
    @IBAction func ME2CodeChanged(sender: AnyObject) {
        ME2CodeField.text = Shepard.Appearance.formatCode(ME2CodeField.text, lastCode: lastCode)
        lastCode = ME2CodeField.text
        ME2CodeLabel.text = ME2CodeField.text
    }

    @IBAction func ME2CodeSubmit(sender: AnyObject) {
        spinner.start()
        var appearance = Shepard.Appearance(ME2CodeField.text?.uppercaseString ?? "", fromGame: game23)
        appearance.convert(toGame: .Game1)
        gender = appearance.gender
        resetSliders()
        ME1GenderSegment.selectedSegmentIndex = appearance.gender == .Male ? 0 : 1
        for (attribute, value) in appearance.contents {
            setSliderValue(attribute, value: value)
        }
        restrictSlidersToGender(gender)
        displayMessages(appearance)
        spinner.stop()
    }
    
    @IBAction func ME1SlidersSubmit(sender: AnyObject) {
        spinner.start()
        var appearance = Shepard.Appearance()
        appearance.game = .Game1
        appearance.gender = gender
        for (attribute, slider) in sliders {
            appearance.contents[attribute] = Int(slider[gender]?.slider?.value ?? 0.0)
        }
        appearance.convert(toGame: game23)
        resetSliders(resetValues: false)
        ME2CodeField.text = appearance.format()
        ME2CodeLabel.text = ME2CodeField.text
        displayMessages(appearance)
        scrollView.contentOffset = CGPointZero
        spinner.stop()
    }
    
    @IBAction func game23Changed(sender: AnyObject) {
        game23 = sender.selectedSegmentIndex == 0 ? .Game2 : .Game3
    }
    
    @IBAction func genderChanged(sender: UISegmentedControl) {
        spinner.start()
        let oldGender = gender
        gender = sender.selectedSegmentIndex == 0 ? .Male : .Female
        if oldGender != gender {
            restrictSlidersToGender(gender)
        }
        spinner.stop()
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        sender.value = roundf(sender.value)
        for (attribute, slider) in sliders {
            for (_, sliderElements) in slider where sliderElements.slider == sender {
                setSliderValue(attribute, value: Int(sender.value))
            }
        }
    }
    
    
    // UITaxtFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() // close keyboard
        return false
    }
    
    
    //MARK: Setup Page Elements
    
    func setupGame23Fields() {
        ME2AlertLabel.hidden = true
        ME2NoticeLabel.hidden = true
        ME2CodeField.delegate = self
    }
    
    var groups: [Shepard.Appearance.AttributeGroups: [Shepard.Gender: Int]] = [:]
    typealias SliderElements = (value: UILabel!, slider: UISlider!, alert: UILabel!, notice: UILabel!)
    var sliders: [Shepard.Appearance.Attributes: [Shepard.Gender: SliderElements]] = [:]
    
    /// using placeholder UIStackView elements, creates all the sliders we need for all the attributes of this group and gender, and adds them to the view hierachy while saving references to variables for later use.
    func setupGame1Fields() {
        groups = [:]
        sliders = [:]
                
        // remove groupStack placeholder:
        ME1Group.removeFromSuperview()
        // remove sliderStack placeholder:
        ME1Slider.removeFromSuperview()
        
        for group in Shepard.Appearance.sortedAttributeGroups {
            for gender in Shepard.Gender.list() {
                
                guard
                let sliderAttributes = Shepard.Appearance.attributeGroups[gender]?[group],
                let groupStack = cloneView(ME1Group) as? ShepardAppearanceME1Group
                else { continue }
            
                // setup groupStack values:
                groupStack.titleLabel?.text = "\(group.title):"
                
                // setup groupStack sliders:
                for attribute in sliderAttributes {
                
                    guard let sliderStack = cloneView(ME1Slider) as? ShepardAppearanceME1Slider
                    else {continue }
                    
                    // setup sliderStack values:
                    sliderStack.titleLabel?.text = "\(attribute.title):"
                    sliderStack.valueSlider?.addTarget(self, action: "sliderChanged:", forControlEvents: UIControlEvents.ValueChanged)
                    sliderStack.alertLabel?.hidden = true
                    sliderStack.noticeLabel?.hidden = true
                    
                    // add sliderStack to view hierarchy:
                    groupStack.slidersStack.addArrangedSubview(sliderStack)
                    
                    // save sliderStack elements for later reference:
                    if sliders[attribute] == nil {
                        sliders[attribute] = [:]
                    }
                    sliders[attribute]?[gender] = (value: sliderStack.valueLabel, slider: sliderStack.valueSlider, alert: sliderStack.alertLabel, notice: sliderStack.noticeLabel)
                    
                    // set slider value to nothing
                    setSliderValue(attribute, value: 1)
                }
                
                // add groupStack to view hierarchy:
                ME1GroupsList.addArrangedSubview(groupStack)
                
                // save whole groupStack for later reference:
                if groups[group] == nil {
                    groups[group] = [:]
                }
                groups[group]?[gender] = ME1GroupsList.arrangedSubviews.count - 1
            }
        }
        
        //show any default notices
        for (attribute, notice) in Shepard.Appearance.defaultNotices {
            showSliderNotice(attribute, notice: notice)
        }
    }
    
    //MARK: Setup Values
    
    func setSliderValue(attribute: Shepard.Appearance.Attributes, value: Int?) {
        for gender in Shepard.Gender.list() { // set for both genders if possible, so we can switch and see same sliders
            guard
            let slider = sliders[attribute]?[gender],
            let maxValue = Shepard.Appearance.slidersMax[gender]?[attribute]?[.Game1]
            else { continue }
            
            //set label
            let valueString = value != nil ? "\(value!)" : "?"
            slider.value?.text = "\(valueString)/\(maxValue)"
            
            //set slider
            if let slider = slider.slider {
                slider.minimumValue = 1
                slider.maximumValue = Float(maxValue ?? 31)
                slider.value = min(slider.maximumValue, Float(value ?? 0))
            }
        }
    }
    
    func displayMessages(appearance: Shepard.Appearance) {
        ME2AlertLabel.text = nil
        ME2NoticeLabel.text = nil
        if appearance.initError != nil {
            ME2AlertLabel.text = appearance.initError!
        } else if appearance.alerts.count > 0 {
            ME2AlertLabel.text = ConvertAlert
        } else if appearance.notices.count > 0 {
            ME2NoticeLabel.text = ConvertNotice
        }
        if ME2AlertLabel.text != nil {
            ME2AlertLabel.sizeToFit()
            ME2AlertLabel.preferredMaxLayoutWidth = ME2AlertLabel.bounds.width - 1.0 //fixes dynamic height stackview bug
            ME2AlertLabel.hidden = false
        } else {
            ME2AlertLabel.hidden = true
        }
        if ME2NoticeLabel.text != nil {
            ME2NoticeLabel.sizeToFit()
            ME2NoticeLabel.preferredMaxLayoutWidth = ME2NoticeLabel.bounds.width - 1.0 //fixes dynamic height stackview bug
            ME2NoticeLabel.hidden = false
        } else {
            ME2NoticeLabel.hidden = true
        }
        for (attribute, alert) in appearance.alerts {
            showSliderAlert(attribute, alert: alert)
        }
        for (attribute, notice) in appearance.notices {
            showSliderNotice(attribute, notice: notice)
        }
        //show any default notices
        for (attribute, notice) in Shepard.Appearance.defaultNotices {
            showSliderNotice(attribute, notice: notice)
        }
    }
    
    func showSliderAlert(attribute: Shepard.Appearance.Attributes, alert: String) {
        for gender in Shepard.Gender.list() {
            if let slider = sliders[attribute]?[gender] {
                slider.alert?.text = alert
                slider.alert?.hidden = false
            }
        }
    }
    
    func showSliderNotice(attribute: Shepard.Appearance.Attributes, notice: String) {
        for gender in Shepard.Gender.list() {
            if let slider = sliders[attribute]?[gender] {
                slider.notice?.text = notice
                slider.notice?.hidden = false
            }
        }
    }
    
    func hideSliderAlert(attribute: Shepard.Appearance.Attributes) {
        for gender in Shepard.Gender.list() {
            if let slider = sliders[attribute]?[gender] {
                slider.alert?.text = ""
                slider.alert?.hidden = true
            }
        }
    }
    
    func hideSliderNotice(attribute: Shepard.Appearance.Attributes) {
        for gender in Shepard.Gender.list() {
            if let slider = sliders[attribute]?[gender] {
                slider.notice?.text = ""
                slider.notice?.hidden = true
            }
        }
    }
    
    func resetSliders(resetValues resetValues: Bool = false) {
        let oldGender = gender //save
        for group in Shepard.Appearance.sortedAttributeGroups {
            for gender in Shepard.Gender.list() {
                
                guard
                let sliderAttributes = Shepard.Appearance.attributeGroups[gender]?[group]
                else { continue }
                
                self.gender = gender
                for attribute in sliderAttributes {
                    if resetValues {
                        setSliderValue(attribute, value: 0)
                    }
                    hideSliderAlert(attribute)
                    hideSliderNotice(attribute)
                }
            }
        }
        gender = oldGender //reset
    }
    
    func restrictSlidersToGender(gender: Shepard.Gender) {
        for (_, group) in groups {
            for (groupGender, groupIndex) in group {
                ME1GroupsList.arrangedSubviews[groupIndex].hidden = groupGender != gender
            }
        }
    }
    
    
    //MARK: Utilities:
    
    func cloneView(view: UIView) -> UIView! {
        let viewData = NSKeyedArchiver.archivedDataWithRootObject(view)
        return NSKeyedUnarchiver.unarchiveObjectWithData(viewData) as? UIView
        //snapshotViewAfterScreenUpdates ?
    }

}
