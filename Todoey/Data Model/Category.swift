//
//  Category.swift
//  Todoey
//
//  Created by 滕施男 on 18/6/18.
//  Copyright © 2018 Shinan Teng. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()  // The key word [List] comes from the RealmSwift to define (to-many) relationship. p.s. This is the forward relationship.
}
