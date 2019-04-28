//
//  DetailInformationAboutCard.swift
//  BusinessCards
//
//  Created by Artem on 14/04/2019.
//  Copyright © 2019 Александр Пономарёв. All rights reserved.
//

import UIKit

class ViewControllerDetailInformationAboutCard: UIViewController, UITableViewDelegate {
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var tableView: UITableView!
    
    let identifier = "cellDataOfCard"
    var cardRecord = CardRecord()

    private enum CardTitles: Int, CaseIterable {
        case Name = 0
        case Surname, Phone, My, Category, Company, Email, Address, Website, Created, Description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        let moreActionButton = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(tappedMore))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: nil)
        navigationItem.rightBarButtonItems = [moreActionButton, shareButton]
        navigationItem.title = cardRecord.name + " " + cardRecord.surname
        
        cardView.setCard(name: cardRecord.name + " " + cardRecord.surname, phone: cardRecord.phone, company: cardRecord.company, imagePath: cardRecord.imagePath)
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
    }
    
    @objc
    private func tappedMore(){
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "popVC") else { return }
        popVC.modalPresentationStyle = .popover
        
        let popOverVC = popVC.popoverPresentationController
        
        popOverVC?.delegate = self
        popOverVC?.barButtonItem = navigationItem.rightBarButtonItems?.first
        popVC.preferredContentSize = CGSize(width: 200, height: 150)
        
        self.present(popVC, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let actionTableView = segue.destination as? ActionsTableViewController else { return }
        actionTableView.card = cardRecord
    }
}

extension ViewControllerDetailInformationAboutCard: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ViewControllerDetailInformationAboutCard: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        guard let cardTitle = CardTitles(rawValue: indexPath.row) else { return cell }
        let value: String?
        
        switch cardTitle {
        case .Address:
            value = self.cardRecord.address
        case .Category:
            value = self.cardRecord.category?.name
        case .Name:
            value = self.cardRecord.name
        case .Surname:
            value = self.cardRecord.surname
        case .Phone:
            value = self.cardRecord.phone
        case .My:
            value = self.cardRecord.isMy ? "Yes":"No"
        case .Email:
            value = self.cardRecord.email
        case .Website:
            value = self.cardRecord.website
        case .Created:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.string(from: self.cardRecord.created)
            value = date
        case .Description:
            value = self.cardRecord.descriptionText
        case .Company:
            value = self.cardRecord.company
        }
        
        cell.textLabel?.text = String(describing: cardTitle)
        cell.detailTextLabel?.text = value
        return cell
    }
}
