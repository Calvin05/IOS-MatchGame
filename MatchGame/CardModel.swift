//
//  CardModel.swift
//  MatchGame
//
//  Created by Cường Nguyễn on 2018-08-27.
//  Copyright © 2018 Cuong Nguyen. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        // Declare an array to store number we've already generated
        var generatedNumberArray = [Int]()
        
        // Declare an array to store the generated cards
        var generatedCardArray = [Card]()
        
        // Randomly generate pairs of cards
        while generatedNumberArray.count < 8 {
            
            // Get a ramdom number
            let randomNumber = arc4random_uniform(13) + 1
            
            // Ensure that random number isn't the one we already have
            if generatedNumberArray.contains(Int(randomNumber)) == false {
                // Log the number
                print(randomNumber)
                
                // Store the number into generatedNumberArray
                generatedNumberArray.append(Int(randomNumber))
                
                // Create the first card object
                let cardOne = Card()
                cardOne.cardName = "card\(randomNumber)"
                
                generatedCardArray.append(cardOne)
                
                // Create the second card object
                let cardTwo = Card()
                cardTwo.cardName = "card\(randomNumber)"
                
                generatedCardArray.append(cardTwo)
            }
        }
        
        // Randomize the array
        for i in 0...generatedCardArray.count-1 {
            
            // Find the random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardArray.count)))
            
            // Swaping code
            let temporaryStorage = generatedCardArray[i]
            generatedCardArray[i] = generatedCardArray[randomNumber]
            generatedCardArray[randomNumber] = temporaryStorage
        }
        // Return the array
        return generatedCardArray
    }
}
