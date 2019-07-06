//
//  DBService.swift
//  BusinessCards
//
//  Created by Mordvintseva Alena on 17/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import Foundation
import RealmSwift

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

    func get(field: String, value: Any, sortBy: String? = nil, ascending: Bool = true) -> Results<T> {
        // swiftlint:disable force_cast
        let predicate = NSPredicate(format: "\(field) == [cd]%@", value as! CVarArg)
        // swiftlint:enable force_cast
        if let sortField = sortBy {
            return realm.objects(T.self).filter(predicate).sorted(byKeyPath: sortField, ascending: ascending)
        }
        return realm.objects(T.self).filter(predicate)
    }

    func get(contains: String, sortBy: String? = nil, ascending: Bool = true) -> Results<T> {
        var fields: [String]
        if T.self == CardRecord.self {
            fields = [.name, .surname, .middleName, .phone, .company, .email, .address, .website, .descriptionText]
        } else if T.self == CategoryRecord.self {
            fields = [.name]
        } else {
            fatalError("Wrong object type")
        }

        let subpredicates = fields.map { property in
            // swiftlint:disable:next implicit_return superfluous_disable_command
            return NSPredicate(format: "%K CONTAINS[cd] %@", property, contains)
        }
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)

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
