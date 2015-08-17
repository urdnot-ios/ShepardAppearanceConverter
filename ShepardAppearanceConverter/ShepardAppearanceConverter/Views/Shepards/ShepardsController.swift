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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isInterfaceBuilder {
            dummyData()
        }

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
    
    
    
    //MARK: Setup Page Elements

    func setupPage() {
        setupShepards()
        setupTableCustomCells()
        tableView.allowsMultipleSelectionDuringEditing = false
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
            let shepard = shepards[indexPath.row].last
            CurrentGame.shepard = shepard
            parentViewController?.performSegueWithIdentifier("Select Shepard", sender: nil)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if indexPath.row < shepards.count {
                let shepard = shepards[indexPath.row].last
                SavedData.deleteShepard(shepard)
                setupShepards()
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.endUpdates()
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
        let sampleShepard1 = Shepard()
        let sampleShepard2 = Shepard()
        SavedData.shepards = [ShepardSet(game: .Game1, shepard: sampleShepard1), ShepardSet(game: .Game1, shepard: sampleShepard2)]
    }

    func setupShepards() {
        shepards = SavedData.shepards.sort { $0.last.modifiedDate.compare($1.last.modifiedDate) == .OrderedDescending }
    }
    
    func setupShepardRow(row: Int, cell: ShepardRowCell) {
        if row < shepards.count {
            let shepard = shepards[row].last
            cell.photo = shepard.photo.image()
            cell.name = shepard.fullName
            cell.title = shepard.title
            cell.date = Date.format(shepard.modifiedDate)
        }
    }
    
}
