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
    
    func configureCell(nameLabel: String, numberLabel: String, companyLabel: String) {
        self.nameLabel.text = nameLabel
        self.numberLabel.text = numberLabel
        self.companyLabel.text = companyLabel
        //self.avatarImageView.image = avatar
    }
}
