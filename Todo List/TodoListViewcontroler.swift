//
//  ViewController.swift
//  Todo List
//
//  Created by Abdallah Ehab on 4/27/20.
//  Copyright © 2020 Abdallah Ehab. All rights reserved.
//

import UIKit

class TodoListViewcontroler: UITableViewController  {

    var itemArray = ["buy milk","go to cinema","play fotball"]
    let defults = UserDefaults.standard
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let items = defults.array(forKey: "TodolistArray") as? [String] {
            itemArray = items 
        }
    }
    
    
    // MARK -> data source method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK -> tablView delgate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
       
        tableView.deselectRow(at: indexPath, animated: true) // after select de select item to look nicer
    }
    // MARK -> add new item
    
    @IBAction func addButtonPressd(_ sender: UIBarButtonItem) {
        var  textfield = UITextField()
        
        let alert = UIAlertController(title: "add new item", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
         // what happend when user pressed on add
            self.itemArray.append(textfield.text!)
            self.defults.set(self.itemArray, forKey: "TodolistArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "creat new item"
           textfield = alertTextfield
        }
         alert.addAction(action)
      
        present(alert, animated: true, completion: nil)
    }
    
}

