//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 滕施男 on 16/5/18.
//  Copyright © 2018 Shinan Teng. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?  // Auto updata container...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //******* MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 这句话的意思是：如果categories unwrap之后不是nil，那就返回categories.count。如果是nil，就返回1
        return categories?.count ?? 1  // This is called - nil coalesing operator...
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories add yet..."
        
        return cell
    }
    
    //******* MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {  //  The value of indexPathForSelectedRow could be nil, since users may select a row without any text, i.e. the blank row. This is why we need to check if it is nil...
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //******* MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField!
        let alert = UIAlertController(title: "Add new Todoey category", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Add category", comment: "Default action"), style: .default, handler: { _ in
            //What will happen once the user click the [Add category] button...
            let newCategory = Category()
            //Set the values...
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }))
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category..."
            textField = alertTextField
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    //******* MARK: - Model manupulation methods
    
    func save(category: Category) -> Void {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("\nError Saving Context: \(error)")
        }
        self.tableView.reloadData() // Force the system to reload the datasource methods again. 这样做的好处就是任何obj的改动，在tableView中都会立即体现。
    }
    
    func loadCategories() -> Void {
        
        categories = realm.objects(Category.self)  // This will return all the categories...
        tableView.reloadData()
    }
    
}
