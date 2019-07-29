//
//  SettingsViewController.swift
//  BusinessCards
//
//  Created by Максим Егоров on 05/07/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let settingsArray = ["Удалить все визитки", "Удалить категорию", "О программе"]
    private let cardService = DBService<CardRecord>()
    private let categoryService = DBService<CategoryRecord>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settingsArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        switch selectedCell?.textLabel?.text {
        case settingsArray[0]:
            let alert = UIAlertController(title: "Вы действительно хотите удалить все визитки?", message: "", preferredStyle: .alert)
            present(alert, animated: true)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.cardService.deleteAll()
            }
            alert.addAction(yesAction)
            let noAction = UIAlertAction(title: "No", style: .destructive)
            alert.addAction(noAction)
            tableView.deselectRow(at: indexPath, animated: true)
        case settingsArray[1]:
            let alert = UIAlertController(title: "Вы хотите удалить все категории?", message: "Карты этой категории удалятся", preferredStyle: .alert)
            present(alert, animated: true)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.categoryService.deleteAll()
            }
            alert.addAction(yesAction)
            let noAction = UIAlertAction(title: "No", style: .destructive)
            alert.addAction(noAction)
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            break
        }
    }
}
