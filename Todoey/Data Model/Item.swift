//
//  Items.swift
//  Todoey
//
//  Created by MilyMozz on 10/09/2018.
//  Copyright © 2018 mozzDev. All rights reserved.
//

import Foundation

//Encodable - Json 형식
class Item : Codable {
    
    var title: String = ""
    var done: Bool = false
    
    
}
