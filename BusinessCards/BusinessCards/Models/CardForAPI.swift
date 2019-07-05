//
//  CardForAPI.swift
//  BusinessCards
//
//  Created by Artem on 05/07/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import Alamofire
import Foundation

struct CardForAPI: Decodable {
    let name: String
    let surname: String
    let middleName: String?
    let phone: String
    let company: String?
    let email: String?
    let address: String?
    let website: String?
}
