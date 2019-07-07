//
//  DetailInformationAboutCard.swift
//  BusinessCards
//
//  Created by Artem on 14/04/2019.
//  Copyright © 2019 Александр Пономарёв. All rights reserved.
//

import UIKit

class ViewControllerDetailInformationAboutCard: UIViewController, UITableViewDelegate {
    @IBOutlet private var cardView: CardView!
    @IBOutlet private var tableView: UITableView!

    let identifier = "cellDataOfCard"
    var cardRecord = CardRecord()
    var cardNetworkService = CardNetworkService()

    private enum CardTitles: Int, CaseIterable {
        case name = 0
        case surname, middleName, phone, category, company, email, address, website, description
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        let moreActionButton = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(tappedMore))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(createQRCode))
        navigationItem.rightBarButtonItems = [moreActionButton, shareButton]
        cardView.setCard(card: cardRecord)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationItem.title = cardRecord.name + " " + cardRecord.surname
        cardView.setCard(card: cardRecord)
        tableView.reloadData()
    }

    @objc private func createQRCode() {
        var stringForQR = ""

        cardNetworkService.getUrlForCard(url: "http://bolart.ru:3013/cards", card: cardRecord) { url in
            stringForQR = "businessCards://" + url.url
            print(stringForQR)
            let data = stringForQR.data(using: String.Encoding.utf8)
            guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
            qrFilter.setValue(data, forKey: "inputMessage")

            guard let qrImage = qrFilter.outputImage else { return }
            let transform = CGAffineTransform(scaleX: 30, y: 30)
            let scaledQrImage = qrImage.transformed(by: transform)

            let context = CIContext()
            guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
            let processedImage = UIImage(cgImage: cgImage)

            guard let popQRCode = self.storyboard?.instantiateViewController(withIdentifier: "popQRCode") as? QRImageViewController else { return }
            popQRCode.modalPresentationStyle = .popover

            let popOverVC = popQRCode.popoverPresentationController

            popOverVC?.delegate = self
            popOverVC?.barButtonItem = self.navigationItem.rightBarButtonItems?.last

            popQRCode.setImage(imageQR: processedImage)
            popQRCode.preferredContentSize = CGSize(width: 200, height: 200)
            self.present(popQRCode, animated: true)
        }
    }
    @objc private func tappedMore() {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "popVC") as? ActionsTableViewControllerAboutCard else { return }
        popVC.modalPresentationStyle = .popover

        let popOverVC = popVC.popoverPresentationController

        popOverVC?.delegate = self
        popOverVC?.barButtonItem = navigationItem.rightBarButtonItems?.first
        popVC.card = cardRecord
        popVC.preferredContentSize = CGSize(width: 250, height: 150)
        self.present(popVC, animated: true)
    }
}

extension ViewControllerDetailInformationAboutCard: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ViewControllerDetailInformationAboutCard: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        guard let cardTitle = CardTitles(rawValue: indexPath.row) else { return cell }
        let value, title: String?

        switch cardTitle {
        case .address:
            title = "Адрес:"
            value = self.cardRecord.address
        case .category:
            title = "Категория:"
            value = self.cardRecord.category?.name
        case .middleName:
            title = "Отчество:"
            value = self.cardRecord.middleName
        case .name:
            title = "Имя:"
            value = self.cardRecord.name
        case .surname:
            title = "Фамилия:"
            value = self.cardRecord.surname
        case .phone:
            title = "Телефон:"
            value = self.cardRecord.phone
        case .email:
            title = "Почта:"
            value = self.cardRecord.email
        case .website:
            title = "Сайт:"
            value = self.cardRecord.website
        case .description:
            title = "Описание:"
            value = self.cardRecord.descriptionText
        case .company:
            title = "Компания:"
            value = self.cardRecord.company
        }

        cell.textLabel?.text = title
        cell.detailTextLabel?.text = value
        return cell
    }
}
