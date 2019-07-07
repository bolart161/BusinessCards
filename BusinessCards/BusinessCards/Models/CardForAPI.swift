//
//  CardForAPI.swift
//  BusinessCards
//
//  Created by Artem on 05/07/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct CardForAPI: Decodable {
    let lastErrorObject: LastErrorObject
    let value: Value
    // swiftlint:disable:next identifier_name
    let ok: Int
}

// MARK: - LastErrorObject
struct LastErrorObject: Decodable {
    // swiftlint:disable:next identifier_name
    let n: Int
}

// MARK: - Value
struct Value: Decodable {
    let id, address, email, company, middleName: String
    let name, phone, surname, website: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case address, company, email, middleName, name, phone, surname, website
    }
}
