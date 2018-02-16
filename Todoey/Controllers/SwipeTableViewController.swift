//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by SpaGettys on 2018/02/15.
//  Copyright © 2018 spagettys. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        //Register your MessageCell.xib file here:
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        // Declare configureTableView
        configureTableView()
    }
    
    // Declare configureTableView here: -> declare the "default" properties for our table.
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
    }
    
    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create our reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        
        cell.delegate = self
        
        return cell
    }
    
    
    //MARK: Swipe Cell Delegate Methods
    
    // handles when user swipes on the cell
    // handles Delete button clicks AND "deep" swipes.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            print("Delete Cell")
            
            self.updateModel(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    // allow for "deep" swiping and automatic tableView reloadeding.
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        // Note: this option will try to remove the row from your TableView.
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // update our data model
        print("Item deleted from superclass")
    }
}
