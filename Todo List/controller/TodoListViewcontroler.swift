//
//  ViewController.swift
//  Todo List
//
//  Created by Abdallah Ehab on 4/27/20.
//  Copyright © 2020 Abdallah Ehab. All rights reserved.
//

import UIKit
import RealmSwift
class TodoListViewcontroler: UITableViewController {

     let realm = try! Realm()
    var todoItems : Results <Item>?
    var selectedCategory : Category? {
        didSet{
           loadData()
        }
    }

 
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
   
    }
    
    
    
    // MARK -> data source method
    // to control our cell in table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
       
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // ternary operater  value = condition (?)--> if condition true   set firist value : if false second value
              cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Iitems added"
    
              }
        
        return cell
    }

    
    
   override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return todoItems?.count ?? 1
    }

    
    //MARK -> tablView delgate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if let item = todoItems?[indexPath.row] {
            do{
               try realm.write(){
                   // item.done = !item.done
                realm.delete(item)
                
                }
                }catch{
                    print("error in update (saving) done property")
                }
            tableView.reloadData()
            
        }
        
    tableView.deselectRow(at: indexPath, animated: true) // after select de select item to look nicer
    }
    
    // MARK: - add new item
    
    @IBAction func addButtonPressd(_ sender: UIBarButtonItem) {
        var  textfield = UITextField()

        let alert = UIAlertController(title: "add new item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
         // what happend when user pressed on add
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write(){
                        let newItem = Item()
                        newItem.title = textfield.text!
                        newItem.dateCreat = Date()
                        currentCategory.items.append(newItem) // append in list container Forward relation
                      
                    }
                }
                catch {
                    print("error in saving context data \(error)")
                }
             
            }
            self.tableView.reloadData()

        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "creat new item"
           textfield = alertTextfield
        }
         alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
    
    
  
    
    
    // mehtod to retrive our Alldata from Database
    
// creat method wit extention param called (with) use in called method ,and actual pram called (request) use inside func , and give methid intail value ,, all this steps to eficent our code and dry and less line of code
    
func loadData(){
 
    todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    
       tableView.reloadData()


    }

    
}

//MARK:- specific section for searchBar
extension TodoListViewcontroler : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        todoItems = todoItems?.filter("title CONTAINS[cd]%@", searchBar.text!).sorted(byKeyPath: "dateCreat", ascending: true)
        tableView.reloadData()
    }

    // method get called when changed happend  in text searchBar , ay change hay7sl fae text bta3 al search bar al methode de ha t call
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // ya3ni hena ana mas7t kol almktob fa mafesh text fa ma3naha any dost 8al
        if searchBar.text?.count == 0 {
            loadData()
            //  make this to dont freez our app , we get the process in main thred
            DispatchQueue.main.async {
    searchBar.resignFirstResponder() //m3naha en e5rog men al search bar, 3shan awl may7sl t8er mayfdlsh gwa searchbar

            }
        }
    }
}

