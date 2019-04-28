//
//  ActionsTableViewController.swift
//  BusinessCards
//
//  Created by Artem on 14/04/2019.
//  Copyright © 2019 Александр Пономарёв. All rights reserved.
//

import UIKit

class ActionsTableViewController: UITableViewController {
    var card: CardRecord!
    let cardsDB = DBService<CardRecord>()
    let array = ["Edit", "Remove", "Create notification"]
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // Edit
            print("Edit")
            dismiss(animated: true)
            return
        case 1: // Remove
            //  Alert with YES / Cancel
            
            // cardsDB.delete(card)
            print("delete")
            // Перейти на экран из которого был вызван экран детальной информации
            return
        case 2: // Create Notification
            print("Create Notitfication")
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
