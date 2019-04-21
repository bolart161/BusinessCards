//
//  DBServiceProtocol.swift
//  BusinessCards
//
//  Created by Mordvintseva Alena on 17/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import RealmSwift
import Foundation

protocol DBServiceProtocol {
    associatedtype ObjectType: Object
    func get(field: String, value: Any, sortBy: String?, ascending: Bool) -> Results<ObjectType>
    func getAll(sortBy: String?, ascending: Bool) -> Results<ObjectType>
    func add(_ data: ObjectType)
    func edit(data: ObjectType, value: [String: Any])
    func delete(_ data: ObjectType)
    func deleteAll()
}
