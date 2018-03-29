//
//  Item.swift
//  Todoey
//
//  Created by 滕施男 on 28/3/18.
//  Copyright © 2018 Shinan Teng. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
    
}
