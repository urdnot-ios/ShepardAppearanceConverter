//
//  AppearanceController.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/18/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit


public class AppearanceController: UIViewController, UITextFieldDelegate {

    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var ME23GameSegment: UISegmentedControl!
    @IBOutlet weak var ME2CodeField: UITextField!
    @IBOutlet weak var ME2CodeLabel: UILabel!
    @IBOutlet weak var ME2NoticeLabel: UILabel!
    @IBOutlet weak var ME2AlertLabel: UILabel!
    @IBOutlet weak var ME2Button: UIButton!
    
    @IBOutlet weak var ME1GroupsList: UIStackView!
    @IBOutlet weak var ME1Group: AppearanceME1Group!
    @IBOutlet weak var ME1Slider: AppearanceME1Slider!
    @IBOutlet weak var ME1Button: UIButton!
    
    //MARK: Variables
    let ConvertAlert = "This conversion may be flawed. See more notes on the sliders below."
    let ConvertNotice = "This conversion is approximate. See more notes on the sliders below."
    
    var game23SliderChoice = GameSequence.GameVersion.Game2 // set by slider
    
    var appearance: Shepard.Appearance { return App.currentGame.shepard.appearance }
    var gender: Shepard.Gender { return App.currentGame.shepard.gender }
    var game: GameSequence.GameVersion { return App.currentGame.gameVersion }
    
    lazy var spinner: Spinner = {
        return Spinner(parent: self)
    }()
    
    //MARK: Page Events
    public override func viewDidLoad() {
        super.viewDidLoad()
        spinner.start()
        setupGame23Fields()
        setupGame1Fields()
        setupData()
        spinner.stop()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //find the scrollview:
        if self.scrollView == nil {
            var parentView = view
            while parentView != nil {
                if let scrollView = parentView as? UIScrollView {
                    self.scrollView = scrollView
                }
                parentView = parentView.superview
            }
        }
//        view.frame.size.height = 100000
//        view.sizeToFit()
    }

    //MARK: Actions
    @IBAction func ME2CodeSelected(sender: UITextField) {
        if Shepard.Appearance.Format.isEmpty(ME2CodeField.text ?? "") {
            ME2CodeField.text = ""
        }
    }
    
    private var lastCode: String?
    @IBAction func ME2CodeChanged(sender: UITextField) {
        ME2CodeField.text = Shepard.Appearance.Format.formatCode(ME2CodeField.text, lastCode: lastCode)
        lastCode = ME2CodeField.text
        ME2CodeLabel.text = ME2CodeField.text
    }

    @IBAction func ME2CodeSubmit(sender: AnyObject) {
        spinner.start()
        var appearance = Shepard.Appearance(ME2CodeField.text?.uppercaseString ?? "", fromGame: game23SliderChoice)
        appearance.convert(toGame: .Game1)
        resetSliders()
        for (attribute, value) in appearance.contents {
            setSliderValue(attribute, value: value)
        }
        displayMessages(appearance)
        spinner.stop()
    }
    
    @IBAction func ME1SlidersSubmit(sender: AnyObject) {
        spinner.start()
        var newAppearance = Shepard.Appearance("", fromGame: .Game1, withGender: gender)
        for (attribute, slider) in sliders {
            newAppearance.contents[attribute] = Int(slider.slider?.value ?? 0.0)
        }
        newAppearance.convert(toGame: game23SliderChoice)
        resetSliders(resetValues: false)
        ME2CodeField.text = newAppearance.format()
        ME2CodeLabel.text = ME2CodeField.text
        displayMessages(appearance)
        scrollView?.contentOffset = CGPointZero
        spinner.stop()
    }
    
    @IBAction func game23Changed(sender: AnyObject) {
        game23SliderChoice = sender.selectedSegmentIndex == 0 ? .Game2 : .Game3
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        sender.value = roundf(sender.value)
        for (attribute, sliderElements) in sliders where sliderElements.slider == sender {
            setSliderValue(attribute, value: Int(sender.value))
        }
    }
    
    public func save() {
        spinner.start()
        if game == .Game1 {
            var newAppearance = Shepard.Appearance("", fromGame: .Game1, withGender: gender)
            for (attribute, slider) in sliders {
                newAppearance.contents[attribute] = Int(slider.slider?.value ?? 0.0)
            }
            App.currentGame.shepard.appearance = newAppearance
        } else if let appearanceCode = ME2CodeField.text {
            App.currentGame.shepard.appearance = Shepard.Appearance(appearanceCode, fromGame: game23SliderChoice, withGender: gender)
        }
        spinner.stop()
    }
    
    // UITaxtFieldDelegate
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() // close keyboard
        return false
    }
    
    
    //MARK: Setup Page Elements
        
    func setupData() {
        ME23GameSegment.selectedSegmentIndex = game == .Game3 ? 1 : 0
        
        // Game 1 Sliders:
        var appearance = App.currentGame.shepard.appearance // value type == copy
        appearance.convert(toGame: .Game1)
        for (attribute, value) in appearance.contents {
            setSliderValue(attribute, value: value)
        }
        // Game 2/3 Code:
        appearance = App.currentGame.shepard.appearance // value type == copy
        appearance.convert(toGame: App.currentGame.gameVersion == .Game3 ? .Game3 : .Game2) 
        ME2CodeField.text = appearance.format()
        
        ME2CodeChanged(ME2CodeField)
    }
    
    func setupGame23Fields() {
        ME2AlertLabel.hidden = true
        ME2NoticeLabel.hidden = true
        ME2CodeField.delegate = self
    }
    
    var groups: [Shepard.Appearance.GroupType: Int] = [:]
    typealias SliderElements = (value: UILabel!, slider: UISlider!, alert: UILabel!, notice: UILabel!)
    var sliders: [Shepard.Appearance.AttributeType: SliderElements] = [:]
    
    /// using placeholder UIStackView elements, creates all the sliders we need for all the attributes of this group and gender, and adds them to the view hierachy while saving references to variables for later use.
    func setupGame1Fields() {
        groups = [:]
        sliders = [:]
                
        // remove groupStack placeholder:
        ME1Group.removeFromSuperview()
        // remove sliderStack placeholder:
        ME1Slider.removeFromSuperview()
        
        for group in Shepard.Appearance.sortedAttributeGroups {
            
            guard
            let sliderAttributes = Shepard.Appearance.attributeGroups[gender]?[group],
            let groupStack = cloneView(ME1Group) as? AppearanceME1Group
            else { continue }
        
            // setup groupStack values:
            groupStack.titleLabel?.text = "\(group.title)"
            
            // setup groupStack sliders:
            for attribute in sliderAttributes {
            
                guard let sliderStack = cloneView(ME1Slider) as? AppearanceME1Slider
                else {continue }
                
                // setup sliderStack values:
                sliderStack.titleLabel?.text = "\(attribute.title):"
                sliderStack.valueSlider?.addTarget(self, action: "sliderChanged:", forControlEvents: UIControlEvents.ValueChanged)
                sliderStack.alertLabel?.hidden = true
                sliderStack.noticeLabel?.hidden = true
                
                // add sliderStack to view hierarchy:
                groupStack.slidersStack.addArrangedSubview(sliderStack)
                
                // save sliderStack elements for later reference:
                sliders[attribute] = (value: sliderStack.valueLabel, slider: sliderStack.valueSlider, alert: sliderStack.alertLabel, notice: sliderStack.noticeLabel)
                
                // set slider value to nothing
                setSliderValue(attribute, value: 1)
            }
            
            // add groupStack to view hierarchy:
            ME1GroupsList.addArrangedSubview(groupStack)
            
            // save whole groupStack for later reference:
            groups[group] = ME1GroupsList.arrangedSubviews.count - 1
        }
        
        //show any default notices
        for (attribute, notice) in Shepard.Appearance.defaultNotices {
            showSliderNotice(attribute, notice: notice)
        }
    }
    
    //MARK: Setup Values
    
    func setSliderValue(attribute: Shepard.Appearance.AttributeType, value: Int?) {
        guard
        let slider = sliders[attribute],
        let maxValue = Shepard.Appearance.slidersMax[gender]?[attribute]?[.Game1]
        else { return }
        
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
    
    func displayMessages(appearance: Shepard.Appearance) {
        ME2AlertLabel.text = nil
        ME2NoticeLabel.text = nil
        if appearance.initError != nil {
            ME2AlertLabel.text = appearance.initError!
        } else if !appearance.alerts.isEmpty {
            ME2AlertLabel.text = ConvertAlert
        } else if !appearance.notices.isEmpty {
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
    
    func showSliderAlert(attribute: Shepard.Appearance.AttributeType, alert: String) {
        if let slider = sliders[attribute] {
            slider.alert?.text = alert
            slider.alert?.hidden = false
        }
    }
    
    func showSliderNotice(attribute: Shepard.Appearance.AttributeType, notice: String) {
        if let slider = sliders[attribute] {
            slider.notice?.text = notice
            slider.notice?.hidden = false
        }
    }
    
    func hideSliderAlert(attribute: Shepard.Appearance.AttributeType) {
        if let slider = sliders[attribute] {
            slider.alert?.text = ""
            slider.alert?.hidden = true
        }
    }
    
    func hideSliderNotice(attribute: Shepard.Appearance.AttributeType) {
        if let slider = sliders[attribute] {
            slider.notice?.text = ""
            slider.notice?.hidden = true
        }
    }
    
    func resetSliders(resetValues resetValues: Bool = false) {
        for group in Shepard.Appearance.sortedAttributeGroups {
            guard
            let sliderAttributes = Shepard.Appearance.attributeGroups[gender]?[group]
            else { continue }
            for attribute in sliderAttributes {
                if resetValues {
                    setSliderValue(attribute, value: 0)
                }
                hideSliderAlert(attribute)
                hideSliderNotice(attribute)
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
