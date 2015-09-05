//
//  ShepardFlowController.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/9/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

class ShepardFlowController: UIViewController {

    static var appInit = false
    static var PopoverCenterPoint: CGPoint?
    var popoverCenterPoint: CGPoint {
        if ShepardFlowController.PopoverCenterPoint == nil {
            return CGPointMake(self.view.bounds.width / 2, (self.view.bounds.height / 2))
        }
        return ShepardFlowController.PopoverCenterPoint!
    }

    
    var appearanceController: AppearanceController? {
        for child in childViewControllers {
            if let appearanceController = child as? AppearanceController{
                return appearanceController
            }
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ShepardFlowController.appInit {
            openApp()
        }
    }
    
    func openApp() {
        if App.allGames.isEmpty {
            createGame(nil)
        } else {
            performSegueWithIdentifier("Select Shepard", sender: nil)
        }
        ShepardFlowController.appInit = false
    }

    @IBAction func saveCode(sender: AnyObject!) {
        appearanceController?.save()
        navigationController?.popViewControllerAnimated(true)
    }

    
    @IBAction func createGame(sender: AnyObject!) {
        App.addNewGame()
        performSegueWithIdentifier("Select Shepard", sender: sender)
    }

    //MARK: Popover Handlers
    
    // note: popovers automatically change behavior between size classes, but I hate the automatic behavior (pull up animation / no navigation controller), so I am changing it up myself.
    var changeableSegues: [String: [UIUserInterfaceSizeClass: String]] = [
        "Edit Origin" : [.Regular: "Edit Origin (Popover)" , .Compact: "Edit Origin (Show)"],
        "Edit Reputation" : [.Regular: "Edit Reputation (Popover)" , .Compact: "Edit Reputation (Show)"],
        "Edit Class" : [.Regular: "Edit Class (Popover)" , .Compact: "Edit Class (Show)"],
    ]
    func performChangeableSegue(identifier: String, sender: AnyObject!) {
        if let segueIdentifier = changeableSegues[identifier]?[view.traitCollection.horizontalSizeClass] {
            performSegueWithIdentifier(segueIdentifier, sender: sender)
        }
    }
    
    // custom appearance stuff:
    var popoverSourceHandler: PopoverSourceHandler?
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let popoverPresentationController = segue.destinationViewController.popoverPresentationController {
            popoverSourceHandler = PopoverSourceHandler(owner: self, source: sender, popoverPresentationController: popoverPresentationController)
        }
    }
}
