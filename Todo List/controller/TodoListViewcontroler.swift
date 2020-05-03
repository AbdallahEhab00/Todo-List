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
   let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       // print(dataPath)
       
      
    
        
       
        // Do any additional setup after loading the view.
//        if let items = defults.array(forKey: "TodolistArray") as? [Item] { // retriveng data by user defult
//            itemArray = items
//        }
        loadData()
   
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
        saveData() // just change in done proprety ,cause here you changed inside and change in done baas

       // tableView.reloadData() // very important to re call method (cellforRow) again and agian fe kol mara ados 3ala item
        
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
            self.saveData() // just change in title proprety , see where are you
            
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "creat new item"
           textfield = alertTextfield
        }
         alert.addAction(action)
      
        present(alert, animated: true, completion: nil)
    }
    // encoding data
    func saveData (){
        let encoder = PropertyListEncoder()
        do {
            let  data = try encoder.encode(itemArray) // encode data (itemarray) to plist file
            try data.write(to: dataPath!) // write data to our file path in plist (writ data in givenlocation)

        }
        catch {
            print("error encoding data \(error)")
        }
       tableView.reloadData()
    }
    
    // decoding our data
    func loadData(){
    
         // paaset al 3enwan bta3 data law fe 3enwan
        
            let decoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: dataPath!) // if datapath have value nill app will crash so should use optional pinding
                itemArray = try decoder.decode([Item].self, from: data)
            
              }
            catch {
                print("error in decoding data \(error)")
                
                 }
                
        
    }
    
}

