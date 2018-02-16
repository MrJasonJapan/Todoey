//
//  ViewController.swift
//  Todoey
//
//  Created by SpaGettys on 2018/02/12.
//  Copyright © 2018 spagettys. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TodoListViewController: SwipeTableViewController {
    
    //MARK: - Top Variables
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        // Category must not be nil
        didSet {
            loadItems()
        }
    }
    
    
    //MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Tableview Datasource Methods
    
    // Note: Since we are sub-classing a UITableView Controller, after we set our delegate functions below, there is NO need to specify a delegate or datasoure withing this class, as this will happen for us behind the scenes.
    // Also notice how we didn't need to create an IBOutlet for a TableView or anything like that either.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // tap into the cell from our super view (trigger the cellForRowAt indexPath delegate method in our super view.)
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! CustomCell
        
        if let item = todoItems?[indexPath.row] {
            // set the cell title
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let theDate = todoItems?[indexPath.row].dateCreated {
                cell.dateCreated.text = formatter.string(from: theDate)
            }
            cell.body?.text = item.title
            // use the Swift Turnary operator to set the cell's checkmark accessory status (on or off)
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.body?.text = "No Items Added Yet"
        }
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done // check/uncheck
                    //realm.delete(item) // deleting
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        //super.updateModel(at: indexPath)
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion) // deleting
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
        
        // reloadData will happen automatically (thanks to editActionsOptionsForRowAt), so we don't need it anymore.
        //tableView.reloadData()
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // show UIAlert for creating a new Todo Item
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            //print(textField.text)
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        //newItem.done = false -> don't need this because we have the default set to false.
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving Item \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

    // load the specified Entity from the persistent container.
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        // undo any search conditions when we change to 0 characters inside the text field
        // then make is so the searchBar stops being the first responder.
        if searchBar.text?.count == 0 {
            loadItems()

            // Dispatch to run in the foreground on the main thread.
            DispatchQueue.main.async {
                // go to the state previous before the searchBar was activated (tapped)
                searchBar.resignFirstResponder()
            }
        }
    }

}

