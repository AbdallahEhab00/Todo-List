//
//  Category.swift
//  Todo List
//
//  Created by Abdallah Ehab on 5/10/20.
//  Copyright © 2020 Abdallah Ehab. All rights reserved.
//

import Foundation
import RealmSwift
class Category : Object {
    @objc dynamic var name : String = ""
    var items = List<Item>() // forward relation , every category have 1 to many forward relation
}
