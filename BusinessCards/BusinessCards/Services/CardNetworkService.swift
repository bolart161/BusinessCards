//
//  CardNetworkService.swift
//  BusinessCards
//
//  Created by Artem on 05/07/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import Alamofire
import Foundation

class CardNetworkService {
    func getUrlForCard(url: String, card: CardRecord, _ completionHandler: @escaping ((UrlFromAPI) -> Void)) {
        let param: Parameters = [
            "name": card.name,
            "surname": card.surname,
            "middleName": card.middleName ?? "",
            "phone": card.phone,
            "website": card.website ?? "",
            "address": card.address ?? "",
            "email": card.email ?? "",
            "company": card.company ?? ""
        ]

        request(url, method: .post, parameters: param).responseData {
            switch $0.result {
            case let .success(data):
                let jsonDecoder = JSONDecoder()
                let response = try? jsonDecoder.decode(UrlFromAPI.self, from: data)
                guard let cardUrl = response else { return }
                completionHandler(cardUrl)
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }

    func getCardFromAPI(url: String, _ completitionHandler: @escaping ((CardForAPI) -> Void)) {
        request(url).responseData {
            switch $0.result {
            case let .success(data):
                let jsonDecoder = JSONDecoder()
                let response = try? jsonDecoder.decode(CardForAPI.self, from: data)
                guard let card = response else { return }
                completitionHandler(card)
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }
}
