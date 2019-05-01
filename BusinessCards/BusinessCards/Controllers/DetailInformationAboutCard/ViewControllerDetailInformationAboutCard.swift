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

    private enum CardTitles: Int, CaseIterable {
        case name = 0
        case surname, middleName, phone, isMy, category, company, email, address, website, created, description
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        let moreActionButton = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(tappedMore))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: nil)
        navigationItem.rightBarButtonItems = [moreActionButton, shareButton]
        navigationItem.title = cardRecord.name + " " + cardRecord.surname

        cardView.setCard(
            name: cardRecord.name + " " + cardRecord.surname,
            phone: cardRecord.phone,
            company: cardRecord.company,
            imagePath: cardRecord.imagePath
        )

        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationItem.title = cardRecord.name + " " + cardRecord.surname
        cardView.setCard(
            name: cardRecord.name + " " + cardRecord.surname,
            phone: cardRecord.phone,
            company: cardRecord.company,
            imagePath: cardRecord.imagePath
        )
        tableView.reloadData()
    }

    @objc private func tappedMore() {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "popVC") as? ActionsTableViewController else { return }
        popVC.modalPresentationStyle = .popover

        let popOverVC = popVC.popoverPresentationController

        popOverVC?.delegate = self
        popOverVC?.barButtonItem = navigationItem.rightBarButtonItems?.first
        popVC.card = cardRecord
        popVC.preferredContentSize = CGSize(width: 200, height: 150)
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
        return 12
    }
    // swiftlint:disable:next function_body_length cyclomatic_complexity
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
        case .isMy:
            title = "Моя:"
            value = self.cardRecord.isMy ? "Да":"Нет"
        case .email:
            title = "Почта:"
            value = self.cardRecord.email
        case .website:
            title = "Сайт:"
            value = self.cardRecord.website
        case .created:
            title = "Создана:"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            let date = dateFormatter.string(from: self.cardRecord.created)
            value = date
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
