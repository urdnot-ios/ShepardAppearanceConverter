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
        if SavedData.shepards.count == 0 {
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
        let newShepard = SavedData.addNewShepard(.Game1)
        CurrentGame.shepard = newShepard
        performSegueWithIdentifier("Select Shepard", sender: sender)
    }

}
