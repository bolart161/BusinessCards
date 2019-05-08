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
    var viewModelOfCards: MainAndCategoriesViewModel<CardRecord>!
    var viewModelOfCategories: MainAndCategoriesViewModel<CategoryRecord>!
    private var items: [CategoryRecord : Results<CardRecord>] = [:] {
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
        search.searchBar.placeholder = "wdewde"
        self.navigationItem.searchController = search
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlertToAddCategory))
        viewModelOfCategories.onCardsChanged = {
            guard let key = $0.last else {return}
            self.items[key] = self.viewModelOfCards.get(field: .category, value: key)
        }
        
        tableView.do {
            $0.register(cellType: CardTableCell.self)
            $0.register(UserHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: "header")
        }
    }
}

private extension MainAndCategoriesViewController {
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
        let alert = UIAlertController(title: "Add category", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Add category"
        }
        let addAction = UIAlertAction(title: "dqwdasas", style: .default) { _ in
            guard let text = alert.textFields?.first?.text else {
                return
            }
            self.addCategory(categoryName: text)
        }
        alert.addAction(addAction)
        present(alert, animated: true)
    }
    
    private func addCategory(categoryName: String) {
        guard !categoryName.isEmpty else {
            return
        }
        let category = CategoryRecord(name: categoryName)
        guard !(items.keys.contains{category.name == $0.name}) else {
            return
        }
        viewModelOfCategories.add(category)
    }
    
    private func fillTableView() {
        for i in viewModelOfCategories.getAll(sotrBy: "name") {
            items[i] = viewModelOfCards.get(field: .category, value: i)
        }
    }
}

extension MainAndCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var key = [CategoryRecord](items.keys)
        key = key.sorted{$0.name > $1.name}
        let count = viewModelOfCards.get(field: .category, value: key[section]).count
        guard isSectionOpened(section) else {
            guard count == 0 else {
                return 1
            }
            return 0
        }
        return count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CardTableCell = tableView.dequeueReusableCell(for: indexPath)
        var key = [CategoryRecord](items.keys)
        key = key.sorted{$0.name > $1.name}
        let category = key[indexPath.section]
        let cards = viewModelOfCards.get(field: .category, value: category)
        cell.configureCell(nameLabel: cards[indexPath.row].name, numberLabel: cards[indexPath.row].phone, companyLabel: cards[indexPath.row].company ?? "")
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
        key = key.sorted{$0.name > $1.name}
        return key[section].name
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? UserHeaderTableViewCell
        header?.tapHandler = { [unowned self] _ in
            self.changeSectionStatus(section)
        }
        
        header?.longTapHandler = { [unowned self] _ in
            var key = [CategoryRecord](self.items.keys)
            key = key.sorted{$0.name > $1.name}
            let alert = UIAlertController(title: key[section].name, message: "", preferredStyle: .alert)
            let addCardAction = UIAlertAction(title: "Add card", style: .default, handler: { _ in
                let createStoryboard = UIStoryboard(name: "CreateAndEditCard", bundle: nil)
                let createAndEditCardViewController = createStoryboard.instantiateViewController(withIdentifier: "createAndEditViewControllerID") as! CreateAndEditCardViewController
                self.navigationController?.pushViewController(createAndEditCardViewController, animated: true)
                self.tableView.reloadSections([section], with: .automatic)
            })
            let deleteAction = UIAlertAction(title: "Delete category", style: .default, handler: { _ in
                var key = [CategoryRecord](self.items.keys)
                self.viewModelOfCategories.delete(data: key[section])
                self.items.remove(at: self.items.index(forKey: key[section])!)
                self.tableView.reloadData()
                print(self.viewModelOfCategories.getAll(sotrBy: "name"))
            })
            alert.addAction(addCardAction)
            alert.addAction(deleteAction)
            self.present(alert, animated: true)
            print("adedwdewd")
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = UIColor.white
            header.textLabel?.textColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "DetailOfCard", bundle: nil)
        let viewControllerDetailInformationAboutCard = mainStoryboard.instantiateViewController(withIdentifier: "ViewControllerDetailInformationAboutCard") as! ViewControllerDetailInformationAboutCard
        navigationController?.pushViewController(viewControllerDetailInformationAboutCard, animated: true)
        var key = [CategoryRecord](items.keys)
        key = key.sorted{$0.name > $1.name}
        let category = key[indexPath.section]
        let cards = viewModelOfCards.get(field: .category, value: category)
        viewControllerDetailInformationAboutCard.cardRecord = cards[indexPath.row]
    }
}

extension MainAndCategoriesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        guard !text.isEmpty else {
            items = oldItems
            return
        }
        items.removeAll()
        for item in viewModelOfCategories.getForSeacrh(field: .name, contains: text) {
            items[item] = viewModelOfCards.get(field: .category, value: item)
        }
    }
}
