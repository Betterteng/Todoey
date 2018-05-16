//
//  ViewController.swift
//  Todoey
//
//  Created by 滕施男 on 26/3/18.
//  Copyright © 2018 Shinan Teng. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet { // 【selectedCategory】之所以是Optional的，是因为只有在CategoryViewController中被设置好后才会得到值。当【selectedCategory】被赋值后，didSet{}中的代码会被执行。
            loadItems()
        }
    }
    
    //let defaults = UserDefaults.standard
    
    let itemArrayKey = "TodoListArray"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  // Grab the context for the persistant container...
    // 上一行代码，如果option + click 到 delegate 关键字上，会发现它是一个Optional的 【UIApplicationDelegate？】，所以要用as来cast一下。
    
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
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
        
        //Ternary Operator
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //******* MARK: - TableView delegate methods
    
    /**
     * Change the status of the row that user selected (Change the checkmark status).
     **/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row]) //The order of these two statements matters. Delete the records in context first, then delete the cell in the table.
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true) // To deploy the flash-grey animation.
    }
    
    
    //******* MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField!
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Add item", comment: "Default action"), style: .default, handler: { _ in
            //What will happen once the user click the [Add item] button...
            let newItem = Item(context: self.context)
            //Set the values...
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
        }))
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item..."
            textField = alertTextField
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //******* MARK: - Model manupulation methods
    
    func saveItems() -> Void {
        do {
            if context.hasChanges {
                try context.save()
            } else {
                print("\nNo changes...")
            }
        } catch {
            print("\nError Saving Context: \(error)")
        }
        self.tableView.reloadData() // Force the system to reload the datasource methods again. 这样做的好处就是任何obj的改动，在tableView中都会立即体现。
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) -> Void { //如果看见了等号，那就意味着给parm了一个default vale，这样call这个method的时候括号里就什么都不用放了。e.g. 看viewDidLoad()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request) // So now, the [itemArray] is corresponding with the [context]...
        } catch {
            print("\nError fetching data from context: \(error)")
        }
        
        tableView.reloadData()
    }
}


//******* MARK: - Search Bar methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
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























