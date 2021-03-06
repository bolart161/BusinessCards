//
//  ImageService.swift
//  BusinessCards
//
//  Created by Mordvintseva Alena on 29/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import Foundation
import UIKit

class ImageService: ImageServiceProtocol {
    func save(image: UIImage) -> String {
        let fileManager = FileManager.default
        let dateString = DateService().getDate()
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dateString)
        let data = image.jpegData(compressionQuality: 0.75)
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        return imagePath
    }

    func get(imagePath: String) -> UIImage? {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: imagePath) {
            return UIImage(contentsOfFile: imagePath)
        }
        print("No image. Path: \(imagePath)")
        return nil
    }
}
