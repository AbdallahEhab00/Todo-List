//
//  CategoryViewController.swift
//  Todo List
//
//  Created by Abdallah Ehab on 5/5/20.
//  Copyright © 2020 Abdallah Ehab. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryViewController: UITableViewController {

     let realm = try! Realm()
    
var categories : Results <Category>? // all data in realm back in form of type result object so we decler from this type to save data back in this var
    
    override func viewDidLoad() {
        super.viewDidLoad()
      retriveCategory()
       
    }
    
    // MARK:- data source method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added"
   
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
   
    //MARK:- Add new Item
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.saveCategory(Category: newCategory)
        }
        alert.addTextField { (alertTextField) in 
            alertTextField.placeholder = "Add a Category"
            textField = alertTextField
        }
        alert.addAction(action)
       present(alert, animated: true, completion: nil)
    }
    
    //MARK:- table view delegate method change view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewcontroler
    // 3shan a3rf ana 3and anhe row dost 3leh ana dost fen men al25r (ana a5trt anhe category w 7ateto fe var)
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row] // pass al categrory aly ana e5trto
        }
    }
    
  
    
    
    //MARK:- manipulate data method (database)
    func saveCategory (Category : Category) {
       
        do{
            try realm.write() {
                realm.add(Category)
            }
        } catch {
            print("error in creating categories data \(error)")
        }
        tableView.reloadData()
    }
    
    func retriveCategory() {

        categories = realm.objects(Category.self) // we add . self to convert category class to object
        
        tableView.reloadData()
    }


}


