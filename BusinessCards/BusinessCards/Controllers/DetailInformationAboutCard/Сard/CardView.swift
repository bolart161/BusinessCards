//
//  CardView.swift
//  BusinessCards
//
//  Created by Artem on 14/04/2019.
//  Copyright © 2019 Александр Пономарёв. All rights reserved.
//

import UIKit

class CardView: UIView {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var phoneLabel: UILabel!
    @IBOutlet private var companyLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func setCard(name: String, phone: String, company: String?, imagePath: String? = nil) {
        var image: UIImage?
        nameLabel.text = name
        phoneLabel.text = phone
        companyLabel.text = company ?? ""

        let fileManager = FileManager.default
        guard let imagePath = imagePath else {
            // swiftlint:disable:next discouraged_object_literal
            imageView.image = #imageLiteral(resourceName: "icon_64x64")
            return
        }
        if fileManager.fileExists(atPath: imagePath) {
            image = UIImage(contentsOfFile: imagePath)
        } else {
            print("No image. Path: \(imagePath)")
        }
        imageView.image = image
    }
}
