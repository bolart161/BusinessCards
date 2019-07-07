//
//  DescriptionCell.swift
//  BusinessCards
//
//  Created by Artem on 07/07/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import Reusable
import UIKit

class DescriptionCell: UITableViewCell, CellProtocol {
    @IBOutlet private var titleText: UILabel!
    @IBOutlet private var valueText: UILabel!

    func setInfo(title: String, value: String?) {
        titleText.text = title
        valueText.text = value
    }
}
