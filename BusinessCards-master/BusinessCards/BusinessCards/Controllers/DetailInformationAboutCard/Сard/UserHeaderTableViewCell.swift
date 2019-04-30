//
//  UserHeaderTableViewCell.swift
//  BusinessCards
//
//  Created by Максим Егоров on 19/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    var didTapped = false
    
    var tapHandler: ((HeaderView) -> Void)!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    @objc private func tapAction() {
        tapHandler?(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
