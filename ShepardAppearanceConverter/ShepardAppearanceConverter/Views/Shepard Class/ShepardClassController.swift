//
//  ShepardClassController.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/29/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

class ShepardClassController: UIViewController {
    @IBOutlet weak var soldierRadio: FauxRadioRow!
    @IBOutlet weak var engineerRadio: FauxRadioRow!
    @IBOutlet weak var adeptRadio: FauxRadioRow!
    @IBOutlet weak var infiltratorRadio: FauxRadioRow!
    @IBOutlet weak var sentinelRadio: FauxRadioRow!
    @IBOutlet weak var vanguardRadio: FauxRadioRow!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
    }
    
    func setupPage() {
        soldierRadio.onClick = {
            CurrentGame.shepard.classTalent = .Soldier
            self.setupRadios()
        }
        engineerRadio.onClick = {
            CurrentGame.shepard.classTalent = .Engineer
            self.setupRadios()
        }
        adeptRadio.onClick = {
            CurrentGame.shepard.classTalent = .Adept
            self.setupRadios()
        }
        infiltratorRadio.onClick = {
            CurrentGame.shepard.classTalent = .Infiltrator
            self.setupRadios()
        }
        sentinelRadio.onClick = {
            CurrentGame.shepard.classTalent = .Sentinel
            self.setupRadios()
        }
        vanguardRadio.onClick = {
            CurrentGame.shepard.classTalent = .Vanguard
            self.setupRadios()
        }
        setupRadios()
    }
    
    func setupRadios() {
        soldierRadio.isOn = CurrentGame.shepard.classTalent == .Soldier
        engineerRadio.isOn = CurrentGame.shepard.classTalent == .Engineer
        adeptRadio.isOn = CurrentGame.shepard.classTalent == .Adept
        infiltratorRadio.isOn = CurrentGame.shepard.classTalent == .Infiltrator
        sentinelRadio.isOn = CurrentGame.shepard.classTalent == .Sentinel
        vanguardRadio.isOn = CurrentGame.shepard.classTalent == .Vanguard
    }
}
