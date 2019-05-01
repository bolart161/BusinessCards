//
//  ImageServiceProtocol.swift
//  BusinessCards
//
//  Created by Mordvintseva Alena on 29/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import Foundation
import UIKit

protocol ImageServiceProtocol {
    func save(image: UIImage) -> String
    func get(imagePath: String) -> UIImage?
}
