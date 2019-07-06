//
//  MyCardsViewController.swift
//  BusinessCards
//
//  Created by Artem on 11/05/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import RealmSwift
import Reusable
import Then
import UIKit

class MyCardsViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModelOfCards: MyCardsViewModel<CardRecord>!
    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModelOfCategories: MyCardsViewModel<CategoryRecord>!

    private var items: [CategoryRecord: [CardRecord]] = [:] {
        didSet {
            self.tableView.reloadData()
        }
    }

    var cardAdded: ((CategoryRecord) -> Void)?
    private lazy var oldItems = items
    var openedSections: [Int: Bool] = [:]
    let search = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillTableView()
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Поиск..."
        self.definesPresentationContext = true
        self.navigationItem.searchController = search
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlertToAddCategory))
        viewModelOfCategories.onCardsChanged = {
            guard let key = $0.last else { return }
            let cards = self.viewModelOfCards.get(field: .category, value: key)
            var res = [CardRecord]()
            for value in cards where value.isMy {
                res.append(value)
            }
            self.items[key] = res
        }

        tableView.do {
            $0.register(cellType: CardTableCell.self)
            $0.register(UserHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: "header")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fillTableView()
        tableView.reloadData()
    }
}

private extension MyCardsViewController {
    private func isSectionOpened(_ section: Int) -> Bool {
        if let status = openedSections[section] {
            return status
        }
        return false
    }

    private func changeSectionStatus(_ section: Int) {
        if let status = openedSections[section] {
            openedSections[section] = !status
        } else {
            openedSections[section] = true
        }
        tableView.reloadSections([section], with: .fade)
    }

    private func addCard(card: CardRecord) {
        viewModelOfCards.add(card)
        tableView.reloadData()
    }

    @objc func showAlertToAddCategory() {
        let alert = UIAlertController(title: "Создать категорию", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Название категории..."
        }
        let addAction = UIAlertAction(title: "Создать", style: .default) { _ in
            guard let text = alert.textFields?.first?.text else {
                return
            }
            self.addCategory(categoryName: text)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true)
    }

    private func addCategory(categoryName: String) {
        guard !categoryName.isEmpty else {
            return
        }
        let category = CategoryRecord(name: categoryName)
        guard !(items.keys.contains { category.name == $0.name }) else {
            return
        }
        viewModelOfCategories.add(category)
        fillTableView()
        tableView.reloadData()
    }

    private func fillTableView() {
        items.removeAll()
        for item in viewModelOfCategories.getAll(sotrBy: .name) {
            let cards = viewModelOfCards.get(field: .category, value: item)
            var res = [CardRecord]()
            for value in cards where value.isMy {
                res.append(value)
            }
            items[item] = res
        }
    }
}

extension MyCardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var key = [CategoryRecord](items.keys)
        key = key.sorted { $0.name < $1.name }
        let category = key[section]
        let cards = [CardRecord](items[category] ?? []) //viewModelOfCards.get(field: .category, value: key[section])
        guard isSectionOpened(section) else {
            guard cards.isEmpty else {
                return 1
            }
            return 0
        }
        return cards.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CardTableCell = tableView.dequeueReusableCell(for: indexPath)
        var key = [CategoryRecord](items.keys)
        key = key.sorted { $0.name < $1.name }
        let category = key[indexPath.section]
        let cards = [CardRecord](items[category] ?? []) // viewModelOfCards.get(field: .category, value: category)
        cell.configureCell(card: cards[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = UIColor.blue
            header.textLabel?.textColor = UIColor.white
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var key = [CategoryRecord](items.keys)
        key = key.sorted { $0.name < $1.name }
        return key[section].name
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? UserHeaderTableViewCell
        header?.tapHandler = { [unowned self] _ in
            self.changeSectionStatus(section)
        }

        header?.longTapHandler = { [unowned self] _ in
            var key = [CategoryRecord](self.items.keys)
            key = key.sorted { $0.name < $1.name }
            let alert = UIAlertController(title: key[section].name, message: "", preferredStyle: .alert)
            let addCardAction = UIAlertAction(title: "Добавить карту", style: .default) { _ in
                let createStoryboard = UIStoryboard(name: "CreateAndEditCard", bundle: nil)
                let createAndEditCardViewController = createStoryboard.instantiateViewController(withIdentifier: "createAndEditViewControllerID")
                    as? CreateAndEditCardViewController
                guard let pCreateAndEditCardViewController = createAndEditCardViewController else { return }
                pCreateAndEditCardViewController.setCategory(category: key[section])
                pCreateAndEditCardViewController.isMyFlag(isMy: true)
                self.navigationController?.pushViewController(pCreateAndEditCardViewController, animated: true)
                self.tableView.reloadSections([section], with: .automatic)
            }
            let deleteAction = UIAlertAction(title: "Удалить категорию", style: .default) { _ in
                self.viewModelOfCategories.delete(data: key[section])
                // swiftlint:disable:next force_unwrapping
                self.items.remove(at: self.items.index(forKey: key[section])!)
                self.tableView.reloadData()
                print(self.viewModelOfCategories.getAll(sotrBy: .name))
            }
            alert.addAction(addCardAction)
            alert.addAction(deleteAction)
            self.present(alert, animated: true)
        }
        return header
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = UIColor.blue
            header.textLabel?.textColor = UIColor.white
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "DetailOfCard", bundle: nil)
        let viewControllerDetailInformationAboutCard = mainStoryboard.instantiateViewController(withIdentifier: "ViewControllerDetailInformationAboutCard")
            as? ViewControllerDetailInformationAboutCard
        var key = [CategoryRecord](items.keys)
        key = key.sorted { $0.name < $1.name }
        let category = key[indexPath.section]
        let cards = [CardRecord](items[category] ?? []) //viewModelOfCards.get(field: .category, value: category)
        viewControllerDetailInformationAboutCard?.cardRecord = cards[indexPath.row]
        guard let pViewControllerDetailInformation = viewControllerDetailInformationAboutCard else { return }
        navigationController?.pushViewController(pViewControllerDetailInformation, animated: true)
    }
}

extension MyCardsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        guard !text.isEmpty else {
            items = oldItems
            return
        }
        items.removeAll()
        for item in viewModelOfCategories.get(field: .name, value: text) {
            let cards = viewModelOfCards.get(field: .category, value: item)
            var res = [CardRecord]()
            for value in cards where value.isMy {
                res.append(value)
            }
            items[item] = res
        }
    }
}
