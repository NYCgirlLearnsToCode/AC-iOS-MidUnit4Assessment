//
//  NewDeck.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Lisa J on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct NewDeck: Codable {
    let deck_id: String
}
//https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6

class NewDeckAPIClient {
    private init() {}
    static let manager = NewDeckAPIClient()
    func getNewDeck(urlStr: String, completionHandler: @escaping (NewDeck) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {return}
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let allResults = try JSONDecoder().decode(NewDeck.self, from: data)
                let decks = allResults
                completionHandler(decks)
            } catch {
                errorHandler(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
