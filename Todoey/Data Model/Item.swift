//
//  Item.swift
//  Todoey
//
//  Created by 滕施男 on 18/6/18.
//  Copyright © 2018 Shinan Teng. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")  // This is the inverse relationship... 引号的items在Category.swift文件中定义好了。。。
}
