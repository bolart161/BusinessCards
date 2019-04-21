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

    func edit(data: T, value: [String: Any]) {
        do {
            try self.realm.write {
                data.setValuesForKeys(value)
            }
        } catch let error as NSError {
            print(error)
        }
    }

    func get(field: String, value: String, sortBy: String? = nil, ascending: Bool = true) -> Results<T> {
        let predicate = NSPredicate(format: "\(field) == [c]%@", value)
        if let sortField = sortBy {
            return realm.objects(T.self).filter(predicate).sorted(byKeyPath: sortField, ascending: ascending)
        }
        return realm.objects(T.self).filter(predicate)
    }

    func getAll(sortBy: String? = nil, ascending: Bool = true) -> Results<T> {
        if let sortField = sortBy {
            return self.realm.objects(T.self).sorted(byKeyPath: sortField, ascending: ascending)
        }
        return self.realm.objects(T.self)
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
