//
//  Category.swift
//  Todoey
//
//  Created by MilyMozz on 13/09/2018.
//  Copyright © 2018 mozzDev. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    //parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    let items = List<Item>()
    
}
