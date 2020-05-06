//
//  ViewController.swift
//  Todo List
//
//  Created by Abdallah Ehab on 4/27/20.
//  Copyright © 2020 Abdallah Ehab. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewcontroler: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

 
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
      //  print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       
        // Do any additional setup after loading the view.
        
    
   
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
        
//        context.delete(itemArray[indexPath.row]) // remove data from database
//        itemArray.remove(at: indexPath.row)
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done  // short way to set oppsit value badl if false = true if true = false
          saveData()

        
        tableView.deselectRow(at: indexPath, animated: true) // after select de select item to look nicer
    }
    
    // MARK: - add new item
    
    @IBAction func addButtonPressd(_ sender: UIBarButtonItem) {
        var  textfield = UITextField()
        
        let alert = UIAlertController(title: "add new item", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
         // what happend when user pressed on add
            let newItem = Item(context: self.context)
            newItem.done = false
            newItem.title = textfield.text!
           newItem.parentCategory = self.selectedCategory
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
      
        do {
           try context.save()
        }
        catch {
            print("error in saving context data \(error)")
        }
       tableView.reloadData()
    }
    
    // mehtod to retrive our Alldata from Database
    
// creat method wit extention param called (with) use in called method ,and actual pram called (request) use inside func , and give methid intail value ,, all this steps to eficent our code and dry and less line of code
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest() , predicate :NSPredicate? = nil ){
    
    let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
      // make it optioinal pinding to use nill defult valu that allow us to call method with no param required
        if let addittionalPredicate = predicate {
        // use NScompoundPredicate  in (request in DB) 3shan nst2bl more than one predicate
    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate ,addittionalPredicate])
         }
         else{
            
            request.predicate = categorypredicate
        }
    
        
       
        do {
              itemArray = try context.fetch(request)
              }
            catch {
                print("error in fetching data throw context \(error)")

                 }
          tableView.reloadData()


    }

    
}

//MARK:- specific section for searchBar
extension TodoListViewcontroler : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
    // search in specific word in DB , NSPerdict is like SQl in database equivelant to write queri in DB in SQl
    // choose your formate depnding on APPlication
    let searchPredicate = NSPredicate.init(format: "title CONTAINS[cd]%@", searchBar.text!)
        
        // order data that retrive  by alphapitical order
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
     loadData(with: request ,predicate: searchPredicate ) // with is extension param used to creat our code more readable to human
 
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

