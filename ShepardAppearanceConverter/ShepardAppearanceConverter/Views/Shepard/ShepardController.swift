//
//  ShepardController.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/29/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

class ShepardController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableHeader: UIView!
    
    @IBOutlet weak var nameField: UITextField!
        var testNameLabel = UILabel()
        var testNameWidth: CGFloat!
    @IBOutlet weak var surnameLabel: UILabel!
        var minSurnameWidth: CGFloat!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var gameSegment: UISegmentedControl!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    @IBOutlet weak var appearanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupPage()
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
        sender.resignFirstResponder()
        if nameField.text == nil || nameField.text!.isEmpty {
            nameField.text = CurrentGame.shepard.name.stringValue
            nameChanged(nameField)
        }
        nameField.superview?.setNeedsLayout()
        nameField.superview?.layoutIfNeeded()
    }
    
    @IBAction func genderChanged(sender: AnyObject) {
        CurrentGame.shepard.setGender(genderSegment.selectedSegmentIndex == 0 ? .Male : .Female)
        setupPage()
    }
    
    @IBAction func gameChanged(sender: AnyObject) {
        let newGame: Shepard.Game = {
            switch gameSegment.selectedSegmentIndex {
            case 0: return .Game1
            case 1: return .Game2
            case 2: return .Game3
            default: return .Game1
            }
        }()
        CurrentGame.changeGame(newGame)
    }
    
    @IBAction func changePhoto(sender: UIButton) {
        pickPhoto()
    }
    
    
    
    //MARK: Setup Page Elements

    func setupPage() {
        genderSegment.selectedSegmentIndex = CurrentGame.shepard.gender == .Male ? 0 : 1
        gameSegment.selectedSegmentIndex = {
            switch CurrentGame.shepard.game {
            case .Game1: return 0
            case .Game2: return 1
            case .Game3: return 2
            }
        }()
        let appearanceCode = CurrentGame.shepard.appearance.format()
        appearanceLabel.text = appearanceCode.isEmpty ? Shepard.Appearance.SampleAppearance : CurrentGame.shepard.appearance.format()
        setupPhoto()
    }
    
    func setupPhoto() {
        photoImageView.image = CurrentGame.shepard.photo.image()
    }

    //MARK: Protocol - UITableViewDelegate
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }

//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    }
    
//    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
//    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    }
    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//    }

//    override func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//    }
    
//    override func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//    }
    
//    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//    }
    
    /**
        Determines what to do when a row is clicked
    */
    
    var prepareAfterIBIncludedSegue: PrepareAfterIBIncludedSegueType = { destination in }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            parentViewController?.performSegueWithIdentifier("Edit Appearance", sender: nil)
        }
    }
    
    //MARK: Table Elements
    
//    func setupTableCustomCells() {
//        let bundle =  NSBundle(forClass: self.dynamicType)
//        tableView.registerNib(UINib(nibName: "ContactDetailsCell", bundle: bundle), forCellReuseIdentifier: "ContactDetail")
//    }
    
    
    //MARK: Photo
    func pickPhoto() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
            
        presentViewController(imagePicker, animated: true, completion: nil)
//        let imageController = UIAlertController(title: title, message: "Select Image", preferredStyle:UIAlertControllerStyle.ActionSheet)
//        self.presentViewController(imageController, animated: true, completion: nil)
//        imageController.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertActionStyle.Default)
//            { action -> Void in
//                if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
//                    imagePicker?.sourceType = .PhotoLibrary
//                    imagePicker!.allowsEditing = true
//                    self.presentViewController(imagePicker!, animated: true, completion: nil)
//                }
//            })
//        imageController.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
//            { action -> Void in
//                if UIImagePickerController.isSourceTypeAvailable(.Camera) {
//                    imagePicker?.sourceType = .Camera
//                    imagePicker!.allowsEditing = true
//                    self.presentViewController(imagePicker!, animated: true, completion: nil)
//                }
//            })
//        imageController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
//            { action -> Void in
//            })
//        if image_picture_URL?.text != nil {
//            let imageURLText = image_picture_URL?.text
//            imageController.addAction(UIAlertAction(title: "Image URL", style: UIAlertActionStyle.Default)
//                { action -> Void in
//                let imageURL = NSURL(string: imageURLText!)
//                let urlRequest = NSURLRequest(URL: imageURL!)
//                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
//                    response, data, error in
//                    if error != nil {
//                        // println("error")
//                    } else {
//                        self.contactImageView.image = UIImage(data: data)
//                    }
//                })
//                
//            })
//        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        if CurrentGame.shepard.setPhoto(image) {
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
