//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 滕施男 on 16/5/18.
//  Copyright © 2018 Shinan Teng. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    //******* MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoryArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //******* MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

    //******* MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField!
        let alert = UIAlertController(title: "Add new Todoey category", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Add category", comment: "Default action"), style: .default, handler: { _ in
            //What will happen once the user click the [Add item] button...
            let newCategory = Category(context: self.context)
            //Set the values...
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            self.saveCategory()
        }))
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category..."
            textField = alertTextField
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    //******* MARK: - Model manupulation methods
    
    func saveCategory() -> Void {
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
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) -> Void {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("\n*****Error fetching data from the database: \(error)\n")
        }
        
        tableView.reloadData()
    }
    
}
