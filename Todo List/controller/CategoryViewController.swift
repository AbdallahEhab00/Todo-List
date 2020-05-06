//
//  CategoryViewController.swift
//  Todo List
//
//  Created by Abdallah Ehab on 5/5/20.
//  Copyright © 2020 Abdallah Ehab. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
   var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retriveCategory()
       
    }
    
    // MARK:- data source method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
   
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
   
    //MARK:- Add new Item
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            self.saveCategory()
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
  
    
    
    //MARK:- manipulate data method (database)
    func saveCategory () {
       
        do{
            try context.save()
        } catch {
            print("error in creating categories data \(error)")
        }
        tableView.reloadData()
    }
    
    func retriveCategory(with request:NSFetchRequest<Category> = Category.fetchRequest()) {
       
        do{
          categoryArray =  try context.fetch(request)
        } catch{
            print("error in retriving Data \(error)")
        }
        tableView.reloadData()
    }
    
    
}


