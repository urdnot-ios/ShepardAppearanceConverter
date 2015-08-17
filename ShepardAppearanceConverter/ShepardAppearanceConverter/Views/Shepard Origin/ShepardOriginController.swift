//
//  ShepardOriginController.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/29/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

class ShepardOriginController: UIViewController {
    
    @IBOutlet weak var earthbornRadio: FauxRadioRow!
    @IBOutlet weak var spacerRadio: FauxRadioRow!
    @IBOutlet weak var colonistRadio: FauxRadioRow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
    }
    
    func setupPage() {
        earthbornRadio.onClick = {
            CurrentGame.shepard.origin = .Earthborn
            self.setupRadios()
        }
        spacerRadio.onClick = {
            CurrentGame.shepard.origin = .Spacer
            self.setupRadios()
        }
        colonistRadio.onClick = {
            CurrentGame.shepard.origin = .Colonist
            self.setupRadios()
        }
        setupRadios()
    }
    
    func setupRadios() {
        earthbornRadio.isOn = CurrentGame.shepard.origin == .Earthborn
        spacerRadio.isOn = CurrentGame.shepard.origin == .Spacer
        colonistRadio.isOn = CurrentGame.shepard.origin == .Colonist
    }
}
