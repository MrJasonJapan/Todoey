//
//  Category.swift
//  Todoey
//
//  Created by SpaGettys on 2018/02/15.
//  Copyright © 2018 spagettys. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    // set our "forward" relationship to many items
    let items = List<Item>()
}
