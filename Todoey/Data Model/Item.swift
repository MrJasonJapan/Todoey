//
//  Item.swift
//  Todoey
//
//  Created by SpaGettys on 2018/02/15.
//  Copyright © 2018 spagettys. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // Set our "reverse" relationship of parentCategory that states:
    // create a link called "parentCategory" that links "items" to a Category.
    // I.E. each item has a parent category that is of the type Category coming from the property called "items"
    // Note: Category.self means: "The Category TYPE"
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
