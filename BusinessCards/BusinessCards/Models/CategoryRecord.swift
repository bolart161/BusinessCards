//
//  Category.swift
//  BusinessCards
//
//  Created by Mordvintseva Alena on 17/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import RealmSwift

class CategoryRecord: Object {
    @objc dynamic var name = ""
    @objc dynamic var isMy = false
    @objc dynamic var created = Date()

    convenience init(name: String, isMy: Bool) {
        self.init()
        self.name = name
        self.isMy = isMy
    }
}
