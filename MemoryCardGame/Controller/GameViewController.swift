//
//  ViewController.swift
//  MemoryCardGame
//
//  Created by user on 9/16/19.
//  Copyright © 2019 Abdel Rahman Ellithy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GameViewController: UIViewController {
    
    let topView = ScoreView()
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var playerStartedPlaying = false
    // assigned in the Main Menu View Controller
    var numOfCards = 48
    var numOfMatches = 3
    
    let jsonUrl = "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    var images = [CardModel]()
    
    // the cards that are going to be used in the game
    var pairsChosen = [CardModel]()
    
    // the cards that are flipped will be added to this array
    var selectedCards = [SelectedCardModel]()
    var numOfCardsSelected = 0
    
    let activityIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // get the images info on the background thread
        DispatchQueue.global(qos: .background).async {
            self.getImagesInfo()
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    // JSON Info Retrieval
    func getImagesInfo() {
        Alamofire.request(jsonUrl, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the data")
                
                let imagesJSON : JSON = JSON(response.result.value!)
                
                self.updateImageData(json: imagesJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    func updateImageData(json: JSON){
        
        let imagesInfo = json["products"].arrayValue

        for product in imagesInfo {
            let title = product["title"].stringValue
            let imageUrl = product["image"]["src"].stringValue

            // checks if the image url is valid
            do {
                let url = URL(string: imageUrl)
                let data = try Data(contentsOf: url!)
                let newCard = CardModel(image: UIImage(data: data)!, title: title)
                images.append(newCard)
            } catch {
                print("Error Getting Image, Image will not be added")
            }
        }
        //randomize the array
        images.shuffle()
        
        //add the number of cards needed to the array
        // so if I am doing 3 matches I will need the same number of cards 3 times
        print(numOfMatches)
        for _ in 0..<numOfMatches {
            pairsChosen += Array(images.prefix(numOfCards/numOfMatches))
        }
        pairsChosen.shuffle()
        
        DispatchQueue.main.async {
            // update ui here
            self.collectionView.reloadData()
            self.collectionView.alpha = CGFloat(1)
            
            self.activityIndicator.alpha = CGFloat(0)
            self.activityIndicator.stopAnimating()
        }
    }
    
    func checkIfCardsAreTheSame(_ selectedCardsArray: [SelectedCardModel]) -> Bool{
        let firstCardSelected = selectedCardsArray[0]
        var sameCard = true
        
        for card in selectedCardsArray {
            if firstCardSelected.title != card.title {
                sameCard = false
                break
            }
        }
        return sameCard
    }

    // is used for when the user gets the wrong match
    func shakeScreen() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.view.center.x - 10, y: self.view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.view.center.x + 10, y: self.view.center.y))
        
        self.view.layer.add(animation, forKey: "position")
    }
    
    func checkIfScoreIsAchieved() {
        if topView.score == (numOfCards/numOfMatches) {
            //stop the timer
            topView.timer.invalidate()
            
            let alert = UIAlertController(title: "Congratulations!", message: "You Finished the Game in \(String(format: "%.1f", topView.timerCounter)) Seconds!", preferredStyle: .alert)
            
            // goes to main menu
            alert.addAction(UIAlertAction(title: "Restart?", style: .default, handler: goToMainMenu(alertAction:)))
            
            self.present(alert, animated: true)
        }
    }

    func goToMainMenu(alertAction: UIAlertAction) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfCards
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardsCollectionViewCell
       
        if pairsChosen.count != 0 {
            cardCell.frontSide.image = pairsChosen[indexPath.row].image
        }
        return cardCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cardCell = collectionView.cellForItem(at: indexPath) as! CardsCollectionViewCell
        
        // start timer if the player starts playing
        if !playerStartedPlaying {
            topView.startTimer()
            playerStartedPlaying = true
        }
        
        // the card has already been matched
        if !cardCell.matched {
            
            // in case the images havent been loaded yet
            if pairsChosen.count != 0 {
                let card = pairsChosen[indexPath.row]
                let seconds = 1.1
                let newSelectedCard = SelectedCardModel(title: card.title, indexPath: indexPath)
                
                // if user taps on the same cards twice
                if !selectedCards.contains(newSelectedCard) {
                    if numOfCardsSelected < numOfMatches {
                        cardCell.flipToFront()
                        numOfCardsSelected += 1
                        selectedCards.append(newSelectedCard)
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            // Executed with a delay here
                            if self.numOfCardsSelected == self.numOfMatches {
                                if self.checkIfCardsAreTheSame(self.selectedCards) {
                                    // player found a match
                                    for selectedCard in self.selectedCards {
                                        let selectedCardCell = collectionView.cellForItem(at: selectedCard.indexPath) as! CardsCollectionViewCell
                                        selectedCardCell.matchedCard()
                                        selectedCardCell.matched = true
                                    }
                                    
                                    self.topView.playerScored()
                                    self.checkIfScoreIsAchieved()
                                    
                                    
                                } else {
                                    // wrong match
                                    
                                    self.shakeScreen()
                                    
                                    // flip back all the cards
                                    for selectedCard in self.selectedCards {
                                        let selectedCardCell = collectionView.cellForItem(at: selectedCard.indexPath) as! CardsCollectionViewCell
                                        selectedCardCell.flipToBack()
                                    }
                                    
                                }
                                self.selectedCards.removeAll()
                                self.numOfCardsSelected = 0
                            }
                        }
                    }
                }
            }
        }


    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = view.frame.size.width
        
        // card sizes
        switch numOfCards {
        case 24:
            width *= 0.2
        case 36, 48:
            width *= 0.135
        default:
            break
        }
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

extension GameViewController {
    func setupUI() {
        self.view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        view.addSubview(topView)
        // start animating the activity indicator
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor(named: "Green")
        
        setUpCollectionView()
        setupTopView()
    }
    func setupTopView() {
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50.0),
            topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50.0),
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topView.heightAnchor.constraint(equalToConstant: 80.0)
            ])
    }
    func setUpCollectionView() {
        collectionView.alpha = 0.0
        collectionView.register(CardsCollectionViewCell.self, forCellWithReuseIdentifier: "cardCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10.0),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0),
            collectionView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10)
            ])
    }
}
