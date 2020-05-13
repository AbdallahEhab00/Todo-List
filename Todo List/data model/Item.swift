//
//  Item.swift
//  Todo List
//
//  Created by Abdallah Ehab on 5/10/20.
//  Copyright © 2020 Abdallah Ehab. All rights reserved.
//

import Foundation
import RealmSwift
class Item : Object { 
    
    @objc dynamic  var title : String = ""
    @objc dynamic  var done : Bool = false
    @objc dynamic var dateCreat : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // every item have invers relation to parentCategory 1 to 1
    

}
