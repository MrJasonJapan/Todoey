//
//  ViewController.swift
//  Todoey
//
//  Created by SpaGettys on 2018/02/12.
//  Copyright © 2018 spagettys. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Play Monhan"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Go Swimming"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Tableview Datasourcde Methods
    
    // Note: Since we are sub-classing a UITableView Controller, after we set our delegate functions below, there is NO need to specify a delegate or datasoure withing this class, as this will happen for us behind the scenes.
    // Also notice how we didn't need to create an IBOutlet for a TableView or anything like that either.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create our reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        // set the cell title
        cell.textLabel?.text = item.title
        // use the Swift Turnary operator to set the cell's checkmark accessory status (on or off)
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // set our model's (item) done property to the opposite of it's current state
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // trigger our cellForRowAt delegate method. (i.e. force the calling of our datasouce methods.)
        tableView.reloadData()
        
        // Go back to a while color after tapping and "grayifiying" the cell's color.   
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // show UIAlert for creating a new Todo Item
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            //print(textField.text)
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // copy our array to our defaults storage (a plist file).
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
}

