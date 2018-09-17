//
//  Data.swift
//  Todoey
//
//  Created by MilyMozz on 13/09/2018.
//  Copyright © 2018 mozzDev. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
    
}
