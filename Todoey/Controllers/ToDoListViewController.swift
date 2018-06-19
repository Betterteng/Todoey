//
//  ViewController.swift
//  Todoey
//
//  Created by 滕施男 on 26/3/18.
//  Copyright © 2018 Shinan Teng. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    let realm = try! Realm()
    var toDoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet { // 【selectedCategory】之所以是Optional的，是因为只有在CategoryViewController中被设置好后才会得到值。当【selectedCategory】被赋值后，didSet{}中的代码会被执行。
            loadItems()
        }
    }
    
    //let defaults = UserDefaults.standard
    
    let itemArrayKey = "TodoListArray"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //******* MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            //Ternary Operator
            //value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added..."
        }
        
        return cell
    }
    
    
    //******* MARK: - TableView delegate methods
    
    /**
     * Change the status of the row that user selected (Change the checkmark status).
     **/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) // To deploy the flash-grey animation.
    }
    
    
    //******* MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField!
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.yyyy"
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Add item", comment: "Default action"), style: .default, handler: { _ in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error storing the Item: \(error)")
                }
            }
            
            self.tableView.reloadData()
        }))
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item..."
            textField = alertTextField
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //******* MARK: - Model manupulation methods
    
    func loadItems() -> Void {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()  //  Now the tableView data source methods will be reloaded...
    }
}


//******* MARK: - Search Bar methods

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            // Tell the system, we're gonna occupy the main thread to do something. p.s. "Something" is in the {sth}...
            // i.e. To run something on the main queue (main thread)...
            DispatchQueue.main.async {
                // So now, the cursor won't show up in the textfield anymore and the keyboard will be toggled down...
                searchBar.resignFirstResponder() // And telling the textfield quit to being the first responder...
            }
        }
    }
}























