//
//  UserHeaderTableViewCell.swift
//  BusinessCards
//
//  Created by Максим Егоров on 19/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import UIKit

class UserHeaderTableViewCell: UITableViewHeaderFooterView {
    var didTapped = false
    // swiftlint:disable:next implicitly_unwrapped_optional
    var tapHandler: ((UserHeaderTableViewCell) -> Void)!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }

    @objc private func tapAction() {
        tapHandler?(self)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
