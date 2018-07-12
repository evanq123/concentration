//
//  Card.swift
//  Concentration
//
//  Created by Evan Quach on 5/16/18.
//  Copyright © 2018 MooCow Productions. All rights reserved.
//

import Foundation

struct Card {
    var isFaceUp = false {
        didSet {
            if isFaceUp {
                isSeen = true
            }
        }
    }
    var isMatched = false
    var isSeen = false
    var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
