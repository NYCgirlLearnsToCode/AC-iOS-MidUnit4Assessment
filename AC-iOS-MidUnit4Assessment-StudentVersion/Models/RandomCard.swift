//
//  RandomCard.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Lisa J on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct RandomCard: Codable {
    let cards: [CardWrapper]
}

struct CardWrapper: Codable {
    let image: String
    let value: String
    let images: ImageWrapper
}

struct ImageWrapper: Codable {
    let png: String
}

//Draw one card from your deck

//https://deckofcardsapi.com/api/deck/<<deck_id>>/draw/?count=1

class RandomCardAPIClient {
    private init () {}
    static let manager = RandomCardAPIClient()
    func getCard(from urlStr: String, completionHandler: @escaping (CardWrapper) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else  {return}
        let request = URLRequest(url:url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let allResults = try JSONDecoder().decode(RandomCard.self, from: data)
                let card = allResults.cards.first
                if let card = card {
                completionHandler(card)
                } else{
                    errorHandler(AppError.noData)
                }
            } catch {
                errorHandler(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
