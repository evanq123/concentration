//
//  Concentration.swift
//  Concentration
//
//  Created by Evan Quach on 5/16/18.
//  Copyright © 2018 MooCow Productions. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards = [Card]()
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            // look at all the cards and see if you can find only one that's face up
            // if so, return it, else return nil
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            // turn all the cards face down except the card at index newValue
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    var score = 0
    var flipCount = 0
    
    static var matchPoints = 20
    static var wasFaceUpPenalty = 10
    static var maxTimePanalty = 10
    
    private var date = Date()
    private var currentDate: Date {
        return Date()
        
    }
    var timeInterval: Int {
        return Int(-date.timeIntervalSinceNow)
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += (Concentration.matchPoints - min(timeInterval, Concentration.maxTimePanalty))
                } else {
                    if cards[index].isSeen {
                        score -= (Concentration.wasFaceUpPenalty + min(timeInterval, Concentration.maxTimePanalty))
                    }
                }
                cards[index].isFaceUp = true
            } else {
                // either no card or two cards face up
                indexOfOneAndOnlyFaceUpCard = index // computed property
            }
        }
        flipCount += 1
        date = currentDate
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.numberOfPairsOfCards(at: \(index)): you must have at least one pair of cards")
        var unShuffeldCards: [Card] = []
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            unShuffeldCards += [card, card]
        }
        // Shuffle the cards
        while !unShuffeldCards.isEmpty {
            let randomIndex = unShuffeldCards.count.arc4Random
            let card = unShuffeldCards.remove(at: randomIndex)
            cards.append(card)
        }
    }
    
}
