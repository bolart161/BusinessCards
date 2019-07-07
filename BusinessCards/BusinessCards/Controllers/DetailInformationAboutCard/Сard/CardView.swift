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

    func setCard(card: CardRecord) {
        nameLabel.text = card.name + " " + card.surname
        phoneLabel.text = card.phone
        companyLabel.text = card.company ?? ""

        guard let imagePath = card.imagePath else {
            imageView.image = UIImage(named: .notFoundImage)
            return
        }
        if !imagePath.isEmpty {
            imageView.image = ImageService().get(imagePath: imagePath)
        }
    }
}
