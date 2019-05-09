//
//  CardTableCell.swift
//  BusinessCards
//
//  Created by Александр Пономарёв on 16/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import Reusable
import UIKit

class CardTableCell: UITableViewCell, NibReusable {
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var companyLabel: UILabel!
    @IBOutlet private var avatarImageView: UIImageView!

    func configureCell(card: CardRecord) {
        self.nameLabel.text = card.name + " " + card.surname
        self.numberLabel.text = card.phone
        self.companyLabel.text = card.company ?? ""

        guard let imagePath = card.imagePath else {
            // swiftlint:disable:next discouraged_object_literal
            avatarImageView.image = #imageLiteral(resourceName: "icon_64x64")
            return
        }
        if !imagePath.isEmpty {
            avatarImageView.image = ImageService().get(imagePath: imagePath)
        }
    }
}
