//
//  ViewController.swift
//  MatchGame
//
//  Created by Cường Nguyễn on 2018-08-27.
//  Copyright © 2018 Cuong Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    
   
    // Declare varibles
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    
    
    
    var timer:Timer?
    var milliseconds:Float = 40000// 40 seconds
    
    

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        
        // Get the getCards method of the CardModel
        cardArray = model.getCards()
        
        // Create Timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // CALVIN: - Timer Methods
    
    @objc func timerElapsed() {
        milliseconds -= 1
        
        // Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        // Set label
        timeLabel.text = "Time Remaining: \(seconds)"
        
        // When the timer has reached 0..
        if milliseconds <= 0 {
            
            //Stop the timer
            timer?.invalidate()
            timeLabel.textColor = UIColor.red
            
            // Check if there are any cars unmachted
            checkGameEnded()
           
        }
    }

    // CALVIN: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get an CardCollectionViewCell object
        let cell = collectionVIew.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        // Set the card for the cell
        cell.setCard(card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if there's any time left
        if milliseconds <= 0 {
            return
        }
        // Get the cell that user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Get the card that user selected
        let card = cardArray[indexPath.row]
        
        if(card.cardFlipped == false && card.cardMatch == false) {
            
            // flip the card
            cell.flip()
            
            // Play the flip sound
            
            SoundManager.playSound(.flip)
            
            // Set the status of the card
            card.cardFlipped = true
            
            // Determine if the first card or second that's flipped over
            if firstFlippedCardIndex == nil {
            // This is the first card being flipped
                firstFlippedCardIndex = indexPath
            } else {
                // This is the first card being flipped
                
                // TODO: Perform the matching logic
                checkForMatches(indexPath)
            }
        }
    } // Enf of the didSelectItem method
    
    // CALVIN: Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
        
        // Get the cells for the two cards that were revealed
        let cardOneCell = collectionVIew.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionVIew.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Get the cards for the two cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // Compare the two cards
        if cardOne.cardName == cardTwo.cardName {
            
            // It's a match
            
            // Play sound
            SoundManager.playSound(.match)
            
            // Set the status of the cards
            cardOne.cardMatch = true
            cardTwo.cardMatch = true
            // Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if there are any cards left unmatched
            checkGameEnded()
            
        } else {
            
            // It's not a match
            
            // Play sound
            SoundManager.playSound(.nomatch)
            
            // Set the status of the cards
            cardOne.cardFlipped = false
            cardTwo.cardFlipped = false
            
            // Flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // Tell the collectionCiew to reload the cell of the first card if it is nil
        if cardOneCell == nil {
            collectionVIew.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // Reset the property that tracks the first card flip
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        
        // Determine if there are any cards unmatched
        var isWon = true
        
        for card in cardArray {
            
            if card.cardMatch == false {
                isWon = false
                break
            }
        }
        
        // Messaging variables
        var title = ""
        var message = ""
        
        // If not, then user won, stop the timer
        if isWon == true {
            
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "you've won"
            
        } else {
            
            // If there are, check if there is any time left
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over!"
            message = "you've lost"
            
        }
        //How won/lost messaging
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String) {
        // Show won/lost messages
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        let restartAction = UIAlertAction(title: "Restart", style: .default) {(action:UIAlertAction!) in
            self.dismiss(animated: false, completion: nil)
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        }
        alert.addAction(restartAction)
        self.present(alert, animated: true, completion: nil)
      
       
        
    }

} // End of ViewControler class

