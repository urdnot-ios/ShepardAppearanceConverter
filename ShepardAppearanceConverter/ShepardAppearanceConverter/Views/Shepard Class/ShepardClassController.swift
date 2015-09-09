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
            App.currentGame.shepard.classTalent = .Soldier
            App.currentGame.shepard.saveAnyChanges()
            self.setupRadios()
        }
        engineerRadio.onClick = {
            App.currentGame.shepard.classTalent = .Engineer
            App.currentGame.shepard.saveAnyChanges()
            self.setupRadios()
        }
        adeptRadio.onClick = {
            App.currentGame.shepard.classTalent = .Adept
            App.currentGame.shepard.saveAnyChanges()
            self.setupRadios()
        }
        infiltratorRadio.onClick = {
            App.currentGame.shepard.classTalent = .Infiltrator
            App.currentGame.shepard.saveAnyChanges()
            self.setupRadios()
        }
        sentinelRadio.onClick = {
            App.currentGame.shepard.classTalent = .Sentinel
            App.currentGame.shepard.saveAnyChanges()
            self.setupRadios()
        }
        vanguardRadio.onClick = {
            App.currentGame.shepard.classTalent = .Vanguard
            App.currentGame.shepard.saveAnyChanges()
            self.setupRadios()
        }
        setupRadios()
    }
    
    func setupRadios() {
        soldierRadio.isOn = App.currentGame.shepard.classTalent == .Soldier
        engineerRadio.isOn = App.currentGame.shepard.classTalent == .Engineer
        adeptRadio.isOn = App.currentGame.shepard.classTalent == .Adept
        infiltratorRadio.isOn = App.currentGame.shepard.classTalent == .Infiltrator
        sentinelRadio.isOn = App.currentGame.shepard.classTalent == .Sentinel
        vanguardRadio.isOn = App.currentGame.shepard.classTalent == .Vanguard
    }
}
