//
//  ViewController.swift
//  Todo List
//
//  Created by Abdallah Ehab on 4/27/20.
//  Copyright © 2020 Abdallah Ehab. All rights reserved.
//

import UIKit

class TodoListViewcontroler: UITableViewController  {

    var itemArray = [Item]()
    let defults = UserDefaults.standard
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "find mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "save the world"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "shopping"
        itemArray.append(newItem3)
      
     


        
       
        // Do any additional setup after loading the view.
        if let items = defults.array(forKey: "TodolistArray") as? [Item] {
            itemArray = items
        }
   
    }
    
    
    
    // MARK -> data source method
    // to control our cell in table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
       
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        // el cell associated with done propite ya3ni 3ala 7asb medas 3leha wala laa
        
        // ternary operater  value = condition (?)--> if condition true   set firist value : if false second value
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//
//        }
        return cell
    }

   override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    //MARK -> tablView delgate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
    // hatnf3 3shan al reverse etnen value bas ya true ya false f al oppist haynf3 3shan no3hom bool bas  8er keda momken maynf3sh altre2a de
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done  // short way to set oppsit value badl if false = true if true = false
        
        tableView.reloadData() // very important to re call method (cellforRow) again and agian fe kol mara ados 3ala item
        
        tableView.deselectRow(at: indexPath, animated: true) // after select de select item to look nicer
    }
    
    // MARK -> add new item
    
    @IBAction func addButtonPressd(_ sender: UIBarButtonItem) {
        var  textfield = UITextField()
        
        let alert = UIAlertController(title: "add new item", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
         // what happend when user pressed on add
            
            let newItem = Item()
            newItem.title = textfield.text!
            self.itemArray.append(newItem)
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

