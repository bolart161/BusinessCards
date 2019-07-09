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
    // swiftlint:disable:next private_outlet
    @IBOutlet var titleText: UILabel!
    // swiftlint:disable:next private_outlet
    @IBOutlet var countText: UILabel!

    var didTapped = false
    // swiftlint:disable:next implicitly_unwrapped_optional
    var tapHandler: ((UserHeaderTableViewCell) -> Void)!
    // swiftlint:disable:next implicitly_unwrapped_optional
    var longTapHandler: ((UserHeaderTableViewCell) -> Void)!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTapAction)))
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAction() {
        tapHandler?(self)
    }

    @objc private func longTapAction() {
        longTapHandler?(self)
    }

    func setHeader(title: String, count: Int) {
        titleText.text = title
        countText.text = String(count)
    }
}
