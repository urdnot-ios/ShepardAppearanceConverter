//
//  ShepardsController.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/12/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

class ShepardsController: UITableViewController {

    var shepards: [ShepardSet] = []
    var updating = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isInterfaceBuilder {
            dummyData()
        }
        
        setupPage()
        
        CurrentGame.onCurrentShepardChange.listen(self) { [weak self] (shepard) in
            if self?.updating == false {
                self?.setupPage(reloadData: true)
            }
        }
        // don't think we need this?
//        SavedData.onShepardsListChange.listen(self) { [weak self] (shepard) in
//            if self?.updating == false {
//                self?.setupPage(reloadData: true)
//            }
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    //MARK: Actions
    
    
    
    //MARK: Setup Page Elements

    func setupPage(reloadData reloadData: Bool = false) {
        tableView.allowsMultipleSelectionDuringEditing = false
        setupTableCustomCells()
        setupShepards()
        if reloadData {
            tableView.reloadData()
        }
        updating = false
    }

    //MARK: Protocol - UITableViewDelegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shepards.count
    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 1
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("Shepard Row") as? ShepardRowCell {
            setupShepardRow(indexPath.row, cell: cell)
            return cell
        }
        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 91
    }
    
    var prepareAfterIBIncludedSegue: PrepareAfterIBIncludedSegueType = { destination in }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < shepards.count {
            view.userInteractionEnabled = false
            let shepard = shepards[indexPath.row].lastPlayed
            CurrentGame.changeShepard(shepard)
            parentViewController?.performSegueWithIdentifier("Select Shepard", sender: nil)
            view.userInteractionEnabled = true
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if indexPath.row < shepards.count {
                view.userInteractionEnabled = false
                updating = true
                let shepard = shepards[indexPath.row].last
                SavedData.deleteShepard(shepard)
                setupShepards()
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.endUpdates()
                updating = false
                view.userInteractionEnabled = true
            }
        }
    }
    
    
    //MARK: Table Elements
    
    func setupTableCustomCells() {
        let bundle =  NSBundle(forClass: self.dynamicType)
        tableView.registerNib(UINib(nibName: "ShepardRowCell", bundle: bundle), forCellReuseIdentifier: "Shepard Row")
    }
    
    //MARK: Table Data
    
    func dummyData() {
        SavedData.addNewShepard()
        SavedData.addNewShepard()
    }

    func setupShepards() {
        shepards = SavedData.shepardSets.sort { $0.sortDate.compare($1.sortDate) == .OrderedDescending }
    }
    
    func setupShepardRow(row: Int, cell: ShepardRowCell) {
        if row < shepards.count {
            let shepard = shepards[row].lastPlayed
            cell.photo = shepard.photo.image()
            cell.name = shepard.fullName
            cell.title = shepard.title
            cell.date = Date.format(shepard.modifiedDate)
        }
    }
    
}
