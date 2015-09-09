//
//  ShepardController.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/29/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

class ShepardController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var headerWrapper: UIView!
    @IBOutlet weak var headerLinks: UIStackView!
    
    @IBOutlet weak var nameField: UITextField!
        var testNameLabel = UILabel()
        var testNameWidth: CGFloat!
    @IBOutlet weak var surnameLabel: UILabel!
        var minSurnameWidth: CGFloat!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var gameSegment: UISegmentedControl!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var originRow: FauxValueRow!
    @IBOutlet weak var reputationRow: FauxValueRow!
    @IBOutlet weak var classRow: FauxValueRow!
    
    @IBOutlet weak var appearanceRow: FauxValueRow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
        App.onCurrentShepardChange.listen(self) { [weak self] (_) in
            self?.setupPage()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureViewForSizeClass()
    }
    
    var lastHorizontalSizeClass: UIUserInterfaceSizeClass?

    func configureViewForSizeClass() {
        if lastHorizontalSizeClass != .Regular && view.traitCollection.horizontalSizeClass == .Regular {
            configureViewForRegularSizeClass()
            lastHorizontalSizeClass = .Regular
        } else if lastHorizontalSizeClass != .Compact && view.traitCollection.horizontalSizeClass == .Compact {
            configureViewForCompactSizeClass()
            lastHorizontalSizeClass = .Compact
        }
    }
    
    func configureViewForRegularSizeClass() {
        for link in headerLinks.arrangedSubviews where link is FauxValueRow {
            if let row = link as? FauxValueRow {
                row.hideTitle = false
            }
        }
    }
    func configureViewForCompactSizeClass() {
        for link in headerLinks.arrangedSubviews where link is FauxValueRow {
            if let row = link as? FauxValueRow {
                row.hideTitle = true
            }
        }
    }
    

    //MARK: Actions
    
    /// Some difficulty changing sizes led to this :/
    @IBAction func startChangingName(sender: AnyObject) {
        testNameLabel.text = nameField.text
        testNameLabel.font = nameField.font
        testNameLabel.sizeToFit()
        testNameWidth = testNameLabel.bounds.width
        testNameLabel.text = " \(Shepard.DefaultSurname)"
        testNameLabel.sizeToFit()
        minSurnameWidth = testNameLabel.bounds.width
    }
    
    @IBAction func nameChanged(sender: UITextField) {
        testNameLabel.text = sender.text
        testNameLabel.sizeToFit()
        if let lastWidth = testNameWidth {
            let widthChange = min(surnameLabel.frame.size.width - minSurnameWidth, testNameLabel.bounds.width - lastWidth)
            nameField.frame.size.width += widthChange
            surnameLabel.frame.origin.x += widthChange
            surnameLabel.frame.size.width -= widthChange
        }
        testNameWidth = testNameLabel.bounds.width
    }
    
    @IBAction func doneChangingName(sender: AnyObject) {
        view.userInteractionEnabled = false
        sender.resignFirstResponder()
        if nameField.text == nil || nameField.text!.isEmpty {
            nameField.text = App.currentGame.shepard.name.stringValue
            nameChanged(nameField)
        } else {
            App.currentGame.shepard.setName(nameField.text)
        }
        App.currentGame.shepard.saveAnyChanges()
        nameField.superview?.setNeedsLayout()
        nameField.superview?.layoutIfNeeded()
        view.userInteractionEnabled = true
    }
    
    @IBAction func genderChanged(sender: AnyObject) {
        view.userInteractionEnabled = false
        App.currentGame.shepard.gender = genderSegment.selectedSegmentIndex == 0 ? .Male : .Female
        App.currentGame.shepard.saveAnyChanges()
        view.userInteractionEnabled = true
    }
    
    @IBAction func gameChanged(sender: AnyObject) {
        view.userInteractionEnabled = false
        let newGame: GameSequence.GameVersion = {
            switch gameSegment.selectedSegmentIndex {
            case 0: return .Game1
            case 1: return .Game2
            case 2: return .Game3
            default: return .Game1
            }
        }()
        App.currentGame.changeGameVersion(newGame)
        view.userInteractionEnabled = true
    }
    
    @IBAction func changePhoto(sender: UIButton) {
        pickPhoto()
    }
    
    //MARK: Setup Page Elements

    func setupPage() {
        view.userInteractionEnabled = false
        genderSegment.selectedSegmentIndex = App.currentGame.shepard.gender == .Male ? 0 : 1
        gameSegment.selectedSegmentIndex = {
            switch App.currentGame.shepard.gameVersion {
            case .Game1: return 0
            case .Game2: return 1
            case .Game3: return 2
            }
        }()
        nameField.text = App.currentGame.shepard.name.stringValue
        surnameLabel.text = Shepard.DefaultSurname
        setupPhoto()
        setupFauxRows()
        
        view.userInteractionEnabled = true
    }
    
    func setupFauxRows() {
        originRow.value = App.currentGame.shepard.origin.rawValue
        originRow.onClick = { [weak self] () in
            let parentController = self?.parentViewController as? ShepardFlowController
            parentController?.performChangeableSegue("Edit Origin", sender: self?.originRow)
        }
        reputationRow.value = App.currentGame.shepard.reputation.rawValue
        reputationRow.onClick = { [weak self] () in
            let parentController = self?.parentViewController as? ShepardFlowController
            parentController?.performChangeableSegue("Edit Reputation", sender: self?.reputationRow)
        }
        classRow.value = App.currentGame.shepard.classTalent.rawValue
        classRow.onClick = { [weak self] () in
            let parentController = self?.parentViewController as? ShepardFlowController
            parentController?.performChangeableSegue("Edit Class", sender: self?.classRow)
        }
        let appearanceCode = App.currentGame.shepard.appearance.format()
        appearanceRow.value = appearanceCode.isEmpty ? Shepard.Appearance.SampleAppearance : App.currentGame.shepard.appearance.format()
        appearanceRow.onClick = { [weak self] () in
            self?.parentViewController?.performSegueWithIdentifier("Edit Appearance", sender: appearanceRow)
        }
    }
    
    func setupPhoto() {
        photoImageView.image = App.currentGame.shepard.photo.image()
    }
    
    //MARK: Photo Picker
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    func pickPhoto() {
        let imageController = UIAlertController(title: nil, message: nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        
        imageController.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertActionStyle.Default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                self.imagePicker.sourceType = .PhotoLibrary
                self.imagePicker.allowsEditing = true
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
        })
        
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil { // prevent simulator error
            imageController.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { _ in
                if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                    self.imagePicker.sourceType = .Camera
                    self.imagePicker.allowsEditing = true
                    self.presentViewController(self.imagePicker, animated: true, completion: nil)
                }
            })
        }
        
        imageController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { _ in })
        
        presentViewController(imageController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        if App.currentGame.shepard.setPhoto(image) {
            setupPhoto()
        } else {
            let alert = UIAlertController(title: nil, message: "There was an error saving this image", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: { (action) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
