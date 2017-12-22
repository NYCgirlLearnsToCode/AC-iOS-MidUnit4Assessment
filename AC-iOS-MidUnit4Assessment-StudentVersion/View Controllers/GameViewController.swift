//
//  ViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q  on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var contentValueLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var deck : NewDeck!
    var randomCard = [CardWrapper](){
        didSet {
            DispatchQueue.main.async{
                self.collectionView.reloadData()
            }
        }
    }
    var deckID = "fzsfbsswihzl"
    var currentCard = [CardWrapper](){
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var currentValue = [String]()
    
    var cardValues = [Int]()
    var totalValue = 0
    let cellSpacing = UIScreen.main.bounds.size.width * 0.05
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDeck()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadDeck(){
        let url = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
        let setDeck : (NewDeck) -> Void = {(onlineDeck: NewDeck) in
            self.deck = onlineDeck
            // print("starting",self.deck, "here")
            print("printed",self.deck.deck_id)
            self.deckID = self.deck.deck_id
            
        }
        
        
        NewDeckAPIClient.manager.getNewDeck(urlStr: url, completionHandler: setDeck, errorHandler: {print($0)})
        
    }
    func getNewCard() {
        let url = "https://deckofcardsapi.com/api/deck/\(deckID)/draw/?count=1"
        let setCard: (CardWrapper) -> Void = {(onlineCard: CardWrapper) in
            self.randomCard = [onlineCard]
            self.currentCard.append(self.randomCard[0])
            
            if self.randomCard[0].value.contains("JACK") {
                self.cardValues.append(10)
            } else if self.randomCard[0].value.contains("KING"){
                self.cardValues.append(10)
            } else if self.randomCard[0].value.contains("QUEEN"){
                self.cardValues.append(10)
            }else if self.randomCard[0].value.contains("ACE"){
                self.cardValues.append(11)
            } else {
                self.cardValues.append(Int(self.randomCard[0].value)!)
            }
            
        }
        RandomCardAPIClient.manager.getCard(from: url, completionHandler: setCard, errorHandler: {print($0)})
    }
    
    
    
    
    @IBAction func newCardButtonPressed(_ sender: UIButton) {
        print(totalValue)
        
        getNewCard()
    }
    
    func lostAlert() {
        let alert = UIAlertController(title: "Lost", message: "You lost! Current Hand Value is over 30, total value is \(totalValue)", preferredStyle: .alert)
        let okButtonInAlertController = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButtonInAlertController)
        present(alert, animated: true, completion: nil)
    }
    
    func winAlert() {
        let alert = UIAlertController(title: "Win", message: "You Won, current Value is 30", preferredStyle: .alert)
        let okButtonInAlertController = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButtonInAlertController)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        currentCard = [CardWrapper]()
        cardValues = [Int]()
        collectionView.reloadData()
        closeToWinAlert()
    }
    
    func closeToWinAlert() {
        let alert = UIAlertController(title: "Close to Win", message: "close to winning! you were only \(30-totalValue) cards away!", preferredStyle: .alert)
        let okButtonInAlertController = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButtonInAlertController)
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return currentCard.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let card = currentCard[indexPath.row]
        //sometimes fails, sometimes doesn't..
        //TODO: Is there data in the arr?
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "gameCardCell", for: indexPath) as! GameCardCollectionViewCell
        if totalValue > 30 {
            print("lost")
            currentCard = [CardWrapper]()
            cardValues = [Int]()
            totalValue = 0
            collectionView.reloadData()
            lostAlert()
            print("lost, reset value to",totalValue)
            //cell.isHidden = true
            
        } else if totalValue == 30 {
            winAlert()
            print("won")
            currentCard = [CardWrapper]()
            cardValues = [Int]()
            totalValue = 0
            collectionView.reloadData()
        }
        //print("value", randomCard[0].value)
        cell.imageView.image = nil
        if card.value.contains("JACK") {
            cell.valueLabel.text = "10"
        } else if card.value.contains("KING"){
            cell.valueLabel.text = "10"
        } else if card.value.contains("QUEEN"){
            cell.valueLabel.text = "10"
        }else if card.value.contains("ACE"){
            cell.valueLabel.text = "11"
        }else {
            cell.valueLabel.text = card.value
        }
    
        //currentValue.append(current)
        //print("added", current)
        let url = card.images.png
        ImageAPIClient.manager.getImage(from: url, completionHandler: {(cell.imageView.image = $0)}, errorHandler: {print($0)})
        cell.setNeedsLayout()
        // print(currentValue)
        
        print(currentCard)
        print(cardValues)
        totalValue = cardValues.reduce(0){$0 + $1}
        contentValueLabel.text = "\(totalValue)"
        return cell
    }
    
    
}
extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numCells: CGFloat = 1
        let numSpaces: CGFloat = numCells + 1
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        return CGSize(width: (screenWidth / 2) / numCells, height: screenHeight * 0.35)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}












