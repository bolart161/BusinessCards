//
//  ActionsTableViewController.swift
//  BusinessCards
//
//  Created by Artem on 14/04/2019.
//  Copyright © 2019 Александр Пономарёв. All rights reserved.
//

import EventKit
import UIKit

class ActionsTableViewControllerAboutCard: UITableViewController {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var card: CardRecord!
    let cardsDB = DBService<CardRecord>()
    let array = ["Редактировать", "Удалить", "Добавить в календарь"]

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tabbarController = self.presentingViewController as? UITabBarController
        let navigationController = tabbarController?.selectedViewController as? UINavigationController
        switch indexPath.row {
        case 0: // Edit
            self.dismiss(animated: true) {
                let window = UIWindow()
                window.backgroundColor = .white
                window.makeKeyAndVisible()
                let storyboard = UIStoryboard(name: "CreateAndEditCard", bundle: nil)
                let createAndEditCardViewController = storyboard.instantiateViewController(withIdentifier: "createAndEditViewControllerID")
                    as? CreateAndEditCardViewController
                createAndEditCardViewController?.setCardRecord(card: self.card)
                if let createAndEditCardViewControllerPush = createAndEditCardViewController {
                    navigationController?.pushViewController(createAndEditCardViewControllerPush, animated: true)
                }
            }
            return
        case 1: // Remove
            deleteCard()
            return
        case 2: // Create Notification
            addEventToCalendar()
            return
        default:
            return
        }
    }

    private func deleteCard() {
        let tabbarController = self.presentingViewController as? UITabBarController
        let navigationController = tabbarController?.selectedViewController as? UINavigationController
        let alert = UIAlertController(title: "Удалить", message: "Удалить эту карту?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(cancelAction)

        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.cardsDB.delete(self.card)
            self.dismiss(animated: true) {
                _ = navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }

    private func goToAppleCalendar(date: Date) {
        DispatchQueue.main.async {
            let interval = date.timeIntervalSinceReferenceDate
            if let url = URL(string: "calshow:\(interval)") {
                UIApplication.shared.open(url)
            }
        }
    }
    private func addEventToCalendar() {
        let title = self.card.name + " "  + self.card.surname
        let name = "Имя: " + card.name + "\n"
        let surname = "Фамилия: " + card.surname + "\n"
        let middleName = "Отчество: " + (card.middleName ?? "") + "\n"
        let phone = "Телефон: " + card.phone + "\n"
        let company = "Компания: " + (card.company ?? "") + "\n"
        let email = "Почта: " + (card.email ?? "") + "\n"
        let address = "Адрес: " + (card.address ?? "") + "\n"
        let website = "Сайт: " + (card.website ?? "") + "\n"
        let notes = name + surname + middleName + phone + company + email + address + website
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.notes = notes
                event.startDate = Date()
                event.endDate = Date()
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    self.goToAppleCalendar(date: event.startDate)
                } catch let error as NSError {
                    print("Error 1: \(error)")
                }
            } else {
                print("Error 2: \(String(describing: error))")
            }
        }
        self.dismiss(animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
}
