//
//  ShepardPopoverController.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/18/15.
//  Copyright © 2015 Emily Ivie. All rights reserved.
//

import UIKit

class ShepardPopoverController: UIViewController {

    @IBOutlet weak var targetView: UIView!
    
    lazy var popoverTargetHandler: PopoverTargetHandler = {
        return PopoverTargetHandler(owner: self, targetView: self.targetView)
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        popoverTargetHandler.setupPopover()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popoverTargetHandler.layoutPopover()
    }
}
