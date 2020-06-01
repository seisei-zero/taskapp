//
//  Task.swift
//  taskapp
//
//  Created by 林正悟 on 2020/05/29.
//  Copyright © 2020 seisei-zero. All rights reserved.
//

import RealmSwift

class Task: Object{
    @objc dynamic var id = 0
    
    @objc dynamic var title = ""
    
    @objc dynamic var contents = ""
    
    @objc dynamic var date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var category = ""
//=""としてあるため、型類推でString型になるはず
}
