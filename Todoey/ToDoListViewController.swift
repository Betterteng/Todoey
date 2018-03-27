//
//  ViewController.swift
//  Todoey
//
//  Created by 滕施男 on 26/3/18.
//  Copyright © 2018 Shinan Teng. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [String]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //******* MARK - TableView datasource methods *******
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    //******* MARK - TableView delegate methods *******
    
    /**
     * Change the status of the row that user selected (Change the checkmark status).
     **/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //If
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //******* MARK - Add new items *******
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField: UITextField!
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Add item", comment: "Default action"), style: .default, handler: { _ in
            //What will happen once the user click the [Add item] button...
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }))
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item..."
            textField = alertTextField
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

