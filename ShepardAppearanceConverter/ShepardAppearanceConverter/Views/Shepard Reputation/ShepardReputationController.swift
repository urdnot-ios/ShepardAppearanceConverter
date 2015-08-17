//
//  ShepardReputationController.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/29/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

class ShepardReputationController: UIViewController {
    
    @IBOutlet weak var ruthlessRadio: FauxRadioRow!
    @IBOutlet weak var warHeroRadio: FauxRadioRow!
    @IBOutlet weak var soleSurvivorRadio: FauxRadioRow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
    }
    
    func setupPage() {
        ruthlessRadio.onClick = {
            CurrentGame.shepard.reputation = .Ruthless
            self.setupRadios()
        }
        warHeroRadio.onClick = {
            CurrentGame.shepard.reputation = .WarHero
            self.setupRadios()
        }
        soleSurvivorRadio.onClick = {
            CurrentGame.shepard.reputation = .SoleSurvivor
            self.setupRadios()
        }
        setupRadios()
    }
    
    func setupRadios() {
        ruthlessRadio.isOn = CurrentGame.shepard.reputation == .Ruthless
        warHeroRadio.isOn = CurrentGame.shepard.reputation == .WarHero
        soleSurvivorRadio.isOn = CurrentGame.shepard.reputation == .SoleSurvivor
    }
}
