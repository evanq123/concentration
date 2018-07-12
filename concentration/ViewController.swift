//
//  ViewController.swift
//  Concentration
//
//  Created by Evan Quach on 5/13/18.
//  Copyright © 2018 MooCow Productions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game: Concentration = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    typealias ThemaData = (emoji: [String], backGroundColor: UIColor, cardBackColor: UIColor)
    
    private let themata: [String: ThemaData] = [
        "people":  (["👩", "👮🏻‍♂️", "👩‍💻", "👨🏾‍🌾", "🧟‍♀️", "👩🏽‍🎨", "👩🏼‍🍳", "🧕🏼", "💆‍♂️", "🤷🏽‍♂️"], #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),
        "animals": (["🐶", "🙊", "🐧", "🦁", "🐆", "🐄", "🐿", "🐠", "🦆", "🦉"], #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
        "faces":  (["😀", "🤪", "😬", "😭", "😎", "😍", "🤠", "😇", "🤩", "🤢"], #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)),
        "fruits": (["🍏", "🥑", "🍇", "🍒", "🍑", "🥝", "🍐", "🍎", "🍉", "🍌"], #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),
        "transport": (["🚗", "🚓", "🚚", "🏍", "✈️", "🚜", "🚎", "🚲", "🚂", "🛴"], #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)),
        "sports": (["🏊🏽‍♀️", "🤽🏻‍♀️", "🤾🏾‍♂️", "⛹🏼‍♂️", "🏄🏻‍♀️", "🚴🏻‍♀️", "🚣🏿‍♀️", "⛷", "🏋🏿‍♀️", "🤸🏼‍♂️"], #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
    ]
    
    private var newTheme: ThemaData {
        let randomIndex = themata.count.arc4Random
        let key = Array(themata.keys)[randomIndex]
        return themata[key]!
    }
    
    private var theme: ThemaData! {
        didSet {
            view.backgroundColor = theme.backGroundColor
            cardButtons.forEach {
                $0.backgroundColor = theme.cardBackColor
                $0.setTitle("", for: UIControlState.normal)
            }
            flipCountLabel.textColor = theme.cardBackColor
            gameScoreLabel.textColor = theme.cardBackColor
            newGameButton.setTitleColor(theme.cardBackColor, for: UIControlState.normal)
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var gameScoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var newGameButton: UIButton! {
        didSet {
            newGameButton.titleLabel?.numberOfLines = 0
        }
    }
    
    @IBAction private func onNewGame(_ sender: UIButton, forEvent event: UIEvent) {
        startNewGame()
    }
    
    private func startNewGame() {
        theme = newTheme
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        flipCountLabel.text = "Flips: \(game.flipCount)"
        gameScoreLabel.text = "Score: \(game.score)"
        emoji = [:]
        emojiChoices = theme.emoji
    }
    
    override func viewDidLoad() {
        startNewGame()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            flipCountLabel.text = "Flips: \(game.flipCount)"
            gameScoreLabel.text = "Score: \(game.score)"
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : theme.cardBackColor
            }
        }
    }
    
    private var emoji = [Int: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: (emojiChoices.count - 1).arc4Random)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    private lazy var emojiChoices: [String] = {
        return theme.emoji
        
    }()
    
}

extension Int {
    var arc4Random: Int {
        switch self {
        case 1...Int.max:
            return Int(arc4random_uniform(UInt32(self)))
        case -Int.max..<0:
            return Int(arc4random_uniform(UInt32(self)))
        default:
            return 0
        }
    }
}
