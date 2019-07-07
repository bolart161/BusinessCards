//
//  CellProtocol.swift
//  BusinessCards
//
//  Created by Artem on 07/07/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import Foundation
import Reusable

protocol CellProtocol: NibReusable {
    func setInfo(title: String, value: String?)
}
