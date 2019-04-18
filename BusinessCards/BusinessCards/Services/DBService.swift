//
//  DBService.swift
//  BusinessCards
//
//  Created by Mordvintseva Alena on 17/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import RealmSwift
import Foundation

class DBService<T: Object>: DBServiceProtocol {
    // !! execute
    private var realm: Realm {
        guard let realm = try? Realm() else {
            fatalError("Realm can't be initialized")
        }
        return realm
    }

    func add(_ data: T) {
        do {
            try self.realm.write {
                self.realm.add(data)
            }
        } catch let error as NSError {
            print(error)
        }
    }

    func get(field: String, value: String) -> Results<T> {
        let predicate = NSPredicate(format: "\(field) == [c]%@", value)
        return realm.objects(T.self).filter(predicate)
    }

    func getAll() -> Results<T> {
        let records = self.realm.objects(T.self)
        return records
    }

    func delete(_ data: T) {
        do {
            try self.realm.write {
                self.realm.delete(data)
            }
        } catch let error as NSError {
            print(error)
        }
    }

    func deleteAll() {
        do {
            try self.realm.write {
                self.realm.deleteAll()
            }
        } catch let error as NSError {
            print(error)
        }
    }
}
