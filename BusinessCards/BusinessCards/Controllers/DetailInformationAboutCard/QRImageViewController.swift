//
//  QRImageViewController.swift
//  BusinessCards
//
//  Created by Artem on 01/05/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import UIKit

class QRImageViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    private var imageQR = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageQR
    }

    func setImage(imageQR: UIImage) {
        self.imageQR = imageQR
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presentingViewController?.view.alpha = 0.3
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presentingViewController?.view.alpha = 1
    }
}
