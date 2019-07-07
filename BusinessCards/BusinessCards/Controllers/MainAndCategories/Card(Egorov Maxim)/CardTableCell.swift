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
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var companyLabel: UILabel!
    @IBOutlet private var avatarImageView: UIImageView!

    func configureCell(card: CardRecord) {
        self.nameLabel.text = card.name + " " + card.surname
        self.numberLabel.text = card.phone
        self.companyLabel.text = card.company ?? ""
        self.nameLabel.layer.cornerRadius = 5
        self.nameLabel.layer.masksToBounds = true
        self.companyLabel.layer.cornerRadius = 5
        self.companyLabel.layer.masksToBounds = true
        self.numberLabel.layer.cornerRadius = 5
        self.numberLabel.layer.masksToBounds = true

        guard let imagePath = card.imagePath else {
            avatarImageView.image = UIImage(named: .notFoundImage)
            return
        }
        if !imagePath.isEmpty {
            avatarImageView.image = ImageService().get(imagePath: imagePath)
        }
    }
}
