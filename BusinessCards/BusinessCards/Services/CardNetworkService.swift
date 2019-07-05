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
}
