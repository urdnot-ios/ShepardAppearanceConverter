//
//  ShepardFlowController.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/9/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

class ShepardFlowController: UIViewController {
    
    var appearanceController: AppearanceController? {
        for child in childViewControllers {
            if let appearanceController = child as? AppearanceController{
                return appearanceController
            }
        }
        return nil
    }

    @IBAction func saveCode(sender: AnyObject) {
        appearanceController?.save()
        navigationController?.popViewControllerAnimated(true)
    }

}
