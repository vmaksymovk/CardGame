import Foundation
import SpriteKit

class GameScene: SKScene {
    var cards: [SKSpriteNode] = []
    var selectedCards: [SKSpriteNode] = []
    var moves: Int = 0
    var timer: Timer?
    var startTime: Date?
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "BG_2")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = self.size
        background.zPosition = -1
        addChild(background)
        
        setupCards()
        startTime = Date()
        startTimer()
    }
    
    func setupCards() {
        let cardNames = ["Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6", "Slot 7", "Slot 8",
                         "Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6", "Slot 7", "Slot 8", "Slot 5", "Slot 6", "Slot 7", "Slot 8"]
        let shuffledCardNames = cardNames.shuffled()
        
        let numRows = 5
        let numCols = 4
        let cardWidth: CGFloat = 100
        let cardHeight: CGFloat = 150
        let padding: CGFloat = 20
        
        for row in 0..<numRows {
            for col in 0..<numCols {
                let card = SKSpriteNode(imageNamed: "Slot")
                card.name = shuffledCardNames[row * numCols + col]
                card.size = CGSize(width: cardWidth, height: cardHeight)
                card.position = CGPoint(x: CGFloat(col) * (cardWidth + padding) + cardWidth / 2 + padding,
                                        y: self.frame.height - CGFloat(row) * (cardHeight + padding) - cardHeight / 2 - padding)
                card.zPosition = 1
                cards.append(card)
                addChild(card)
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if let startTime = startTime {
            let elapsedTime = Date().timeIntervalSince(startTime)
            let minutes = Int(elapsedTime) / 60
            let seconds = Int(elapsedTime) % 60
            print("Time: \(minutes):\(seconds)")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesAtLocation = nodes(at: location)
            
            for node in nodesAtLocation {
                if let card = node as? SKSpriteNode, card.texture == SKTexture(imageNamed: "Slot"), !selectedCards.contains(card) {
                    let cardName = card.name!
                    card.texture = SKTexture(imageNamed: cardName)
                    selectedCards.append(card)
                    
                    if selectedCards.count == 2 {
                        moves += 1
                        if selectedCards[0].name == selectedCards[1].name {
                            // Карты совпадают, оставляем их открытыми
                            selectedCards.removeAll()
                            checkWinCondition()
                        } else {
                            // Карты не совпадают, переворачиваем обратно
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                for card in self.selectedCards {
                                    card.texture = SKTexture(imageNamed: "Slot")
                                }
                                self.selectedCards.removeAll()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkWinCondition() {
        let allCardsFlipped = cards.allSatisfy { $0.texture != SKTexture(imageNamed: "Slot") }
        
        if allCardsFlipped {
            showWinScreen()
        }
    }
    
    func showWinScreen() {
        let youWinNode = SKSpriteNode(imageNamed: "Youwin")
        youWinNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        youWinNode.zPosition = 10
        addChild(youWinNode)
        
        timer?.invalidate()
    }
}
