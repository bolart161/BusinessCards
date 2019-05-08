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
    var longTapHandler: ((UserHeaderTableViewCell) -> Void)!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTapAction)))
    }

    @objc private func tapAction() {
        tapHandler?(self)
    }
    
    @objc private func longTapAction() {
        longTapHandler?(self)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
