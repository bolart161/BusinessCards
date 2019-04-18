//
//  CardRecord.swift
//  BusinessCards
//
//  Created by Mordvintseva Alena on 16/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import RealmSwift

class CardRecord: Object {
    @objc dynamic var category: CategoryRecord?
    @objc dynamic var isMy = false
    @objc dynamic var name = ""
    @objc dynamic var surname = ""
    @objc dynamic var phone = ""
    @objc dynamic var company: String?
    @objc dynamic var email: String?
    @objc dynamic var address: String?
    @objc dynamic var imagePath: String?
    @objc dynamic var website: String?
    @objc dynamic var descriptionText: String?
    @objc dynamic var created = Date()

    convenience init(name: String, surname: String, phone: String, isMy: Bool, category: CategoryRecord) {
        self.init()
        self.name = name
        self.surname = surname
        self.phone = phone
        self.isMy = isMy
        self.category = category
    }
}
