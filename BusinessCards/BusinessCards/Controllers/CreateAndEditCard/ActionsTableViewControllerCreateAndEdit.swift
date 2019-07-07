//
//  ActionsTableViewController.swift
//  BusinessCards
//
//  Created by Artem on 02/05/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import UIKit

class ActionsTableViewControllerCreateAndEdit: UITableViewController {
    let array = ["Считать QR", "Считать с камеры"]
    var card = CardRecord()

    private func readQR() {
        // Open camera
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // Read QR
            self.dismiss(animated: true) {
                self.readQR()
            }
            return
        case 1: // Read Card from Camera
            // Саша
            // Распознавание текста с карты и размещение
            // текста в соответствующих полях
            self.dismiss(animated: true) {
            }
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
