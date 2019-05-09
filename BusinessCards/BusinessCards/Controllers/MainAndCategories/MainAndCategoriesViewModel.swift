//
//  MainAndCategoriesViewModel.swift
//  BusinessCards
//
//  Created by Максим Егоров on 03/05/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import Foundation
import RealmSwift

class MainAndCategoriesViewModel<T: Object> {
    // swiftlint:disable:next implicitly_unwrapped_optional
    private let realmService: DBService<T>!
    var onCardsChanged: ((Results<T>) -> Void)?
    // swiftlint:disable:next implicitly_unwrapped_optional
    private var cards: Results<T>! {
        didSet {
            onCardsChanged?(cards)
        }
    }

    init(realmService: DBService<T>) {
        self.realmService = realmService
    }

    func add(_ data: T) {
        realmService.add(data)
        cards = realmService.getAll()
    }

    func get(field: String, value: Any, sortBy: String? = nil, ascending: Bool = true) -> Results<T> {
        return realmService.get(field: field, value: value, sortBy: sortBy, ascending: ascending)
    }

    func getAll(sotrBy: String?) -> Results<T> {
        return realmService.getAll(sortBy: sotrBy, ascending: false)
    }

    func getForSeacrh(field: String, contains: String) -> Results<T> {
        return realmService.get(field: field, contains: contains)
    }

    func delete(data: T) {
        realmService.delete(data)
    }
}
