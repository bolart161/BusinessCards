//
//  MainAndCategoriesViewController.swift
//  BusinessCards
//
//  Created by Artem on 15/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import RealmSwift
import Reusable
import Then
import UIKit

class MainAndCategoriesViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    private lazy var items: [CategoryRecord: Results<CardRecord>] = [:]
    let cards = DBService<CardRecord>() // cards BD
    let categories = DBService<CategoryRecord>()
    var openedSections: [Int: Bool] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.do {
            $0.register(cellType: CardTableCell.self)
            $0.register(UserHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: "header")
        }
    }

    func isSectionOpened(_ section: Int) -> Bool {
        if let status = openedSections[section] {
            return status
        }
        return false
    }

    func changeSectionStatus(_ section: Int) {
        if let status = openedSections[section] {
            openedSections[section] = !status
        } else {
            openedSections[section] = true
        }
        tableView.reloadData()
    }
}

extension MainAndCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = [CategoryRecord](items.keys)
        guard isSectionOpened(section) else {
            return 1
        }
        return cards.get(field: .category, value: key[section]).count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CardTableCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = UIColor.blue
            header.textLabel?.textColor = UIColor.white
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = [CategoryRecord](items.keys)
        return key[section].name
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? UserHeaderTableViewCell
        header?.tapHandler = { [unowned self] _ in
            self.changeSectionStatus(section)
        }
        return header
    }
}