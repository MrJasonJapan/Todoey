//
//  ViewController.swift
//  Todoey
//
//  Created by SpaGettys on 2018/02/12.
//  Copyright © 2018 spagettys. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    //MARK: - Top Variables
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
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
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // update test using the setValue() method.
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        // delete test
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        // set our model's (item) done property to the opposite of it's current state
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
        saveItems()
        
        // Go back to a while color after tapping and "grayifiying" the cell's color.   
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // show UIAlert for creating a new Todo Item
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            //print(textField.text)
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // trigger our cellForRowAt delegate method. (i.e. force the calling of our datasouce methods.)
        tableView.reloadData()
    }
    
    // load the specified Entity from the persistent container.
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // use additionalPredicate only when predicate is not nil (predicate will be nill when calling loadItems with no params)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            // default to only fetching based on the currently selected category.
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching Items from context: \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //print(searchBar.text)
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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

