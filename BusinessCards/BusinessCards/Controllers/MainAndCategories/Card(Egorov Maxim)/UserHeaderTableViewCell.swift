//
//  UserHeaderTableViewCell.swift
//  BusinessCards
//
//  Created by Максим Егоров on 19/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import Reusable
import UIKit

class UserHeaderTableViewCell: UITableViewHeaderFooterView, NibReusable {
    @IBOutlet private var titleText: UILabel!
    @IBOutlet private var countText: UILabel!
    @IBOutlet private var arrowImage: UIImageView!

    var didTapped = false
    // swiftlint:disable:next implicitly_unwrapped_optional
    var tapHandler: ((UserHeaderTableViewCell) -> Void)!
    // swiftlint:disable:next implicitly_unwrapped_optional
    var longTapHandler: ((UserHeaderTableViewCell) -> Void)!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func open() {
        self.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
    }

    func commonInit() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTapAction)))
    }

    @objc private func tapAction() {
        tapHandler?(self)
    }

    @objc private func longTapAction() {
        longTapHandler?(self)
    }

    func setHeader(title: String, count: Int) {
        var countStr: String = ""
        switch count % 10 {
        case 1:
            countStr = "карта"
        case 2, 3, 4:
            countStr = "карты"
        case 0, 5, 6, 7, 8, 9:
            countStr = "карт"
        default:
            countStr = ""
        }

        titleText.text = title
        countText.text = String(count) + " " + countStr
    }
}
