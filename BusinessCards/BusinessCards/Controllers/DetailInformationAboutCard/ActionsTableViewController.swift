//
//  ActionsTableViewController.swift
//  BusinessCards
//
//  Created by Artem on 14/04/2019.
//  Copyright © 2019 Александр Пономарёв. All rights reserved.
//

import UIKit

class ActionsTableViewController: UITableViewController {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var card: CardRecord!
    let cardsDB = DBService<CardRecord>()
    let array = ["Edit", "Remove", "Create notification"]

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigationController = self.presentingViewController as? UINavigationController

        switch indexPath.row {
        case 0: // Edit
            // переход на экран Алены
            //=================
            //
            //=================
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
            let alert = UIAlertController(title: "Delete", message: "Delete this card?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)

            let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
                self.cardsDB.delete(self.card)
                self.dismiss(animated: true) {
                    _ = navigationController?.popViewController(animated: true)
                }
            }
            alert.addAction(deleteAction)
            present(alert, animated: true)
            return
        case 2: // Create Notification
            return
        default:
            return
        }
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
