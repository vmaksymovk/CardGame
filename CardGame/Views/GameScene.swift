import Foundation
import SpriteKit
import AVFoundation

class GameScene: SKScene {
    var cards: [SKSpriteNode] = []
    var selectedCards: [SKSpriteNode] = []
    var moves: Int = 0
    var timer: Timer?
    var startTime: Date?
    var movesLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var cardBackTexture: SKTexture = SKTexture(imageNamed: "Slot")
    var isInteractionEnabled: Bool = true

    var backgroundMusicPlayer: AVAudioPlayer?
    
    var savedState: GameState?

    override func didMove(to view: SKView) {
        if let savedState = savedState {
            restoreState(savedState)
        } else {
            let background = SKSpriteNode(imageNamed: "BG_2")
            background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            background.zPosition = -1
            background.scale(to: CGSize(width: 750, height: 950))
            addChild(background)

            setupCards()
            setupHUD()
            setupSettingsButton()
            startTime = Date()
            startTimer()
            playBackgroundMusic()
        }
    }

    func setupCards() {
        let cardNames = ["Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6", "Slot 7", "Slot 8",
                         "Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6", "Slot 7", "Slot 8"]
        let shuffledCardNames = cardNames.shuffled()

        let numRows = 4
        let numCols = 4
        let cardWidth: CGFloat = (self.frame.width - CGFloat(numCols + 1) * 20) / CGFloat(numCols)
        let cardHeight: CGFloat = cardWidth * 1.35
        let padding: CGFloat = 20

        let totalWidth = CGFloat(numCols) * cardWidth + CGFloat(numCols - 1) * padding
        let totalHeight = CGFloat(numRows) * cardHeight + CGFloat(numRows - 1) * padding

        let startX = (self.frame.width - totalWidth) / 2 + cardWidth / 2
        let startY = self.frame.height - (self.frame.height - totalHeight) / 2 - cardHeight / 2 - 40

        for row in 0..<numRows {
            for col in 0..<numCols {
                let card = SKSpriteNode(texture: cardBackTexture)
                card.name = shuffledCardNames[row * numCols + col]
                card.size = CGSize(width: cardWidth + 10, height: cardHeight - 10)
                card.position = CGPoint(x: startX + CGFloat(col) * (cardWidth + padding),
                                        y: startY - CGFloat(row) * (cardHeight + padding))
                card.zPosition = 1
                cards.append(card)
                addChild(card)
            }
        }
    }

    func setupHUD() {
        let frameSize = CGSize(width: 450, height: 50)

        if movesLabel == nil || timerLabel == nil {
            let frame3 = SKSpriteNode(imageNamed: "Frame_3")
            frame3.size = frameSize
            frame3.position = CGPoint(x: self.frame.midX, y: self.frame.height - frameSize.height / 2 - 150)
            frame3.zPosition = 10
            addChild(frame3)

            movesLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
            movesLabel.text = "Moves: 0"
            movesLabel.fontSize = 25
            movesLabel.fontColor = .white
            movesLabel.position = CGPoint(x: -frameSize.width / 4, y: -10)
            movesLabel.zPosition = 11
            frame3.addChild(movesLabel)

            timerLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
            timerLabel.text = "Time: 0:00"
            timerLabel.fontSize = 25
            timerLabel.fontColor = .white
            timerLabel.position = CGPoint(x: frameSize.width / 4, y: -10)
            timerLabel.zPosition = 11
            frame3.addChild(timerLabel)
        }
    }

    func setupSettingsButton() {
        let settingsButton = SKSpriteNode(imageNamed: "Settings")
        settingsButton.position = CGPoint(x: self.frame.maxX - 350, y: self.frame.maxY - 120)
        settingsButton.size = CGSize(width: 55, height: 55)
        settingsButton.name = "settingsButton"
        settingsButton.zPosition = 10
        addChild(settingsButton)
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        if let startTime = startTime {
            let elapsedTime = Date().timeIntervalSince(startTime)
            let minutes = Int(elapsedTime) / 60
            let seconds = Int(elapsedTime) % 60
            timerLabel.text = String(format: "Time: %d:%02d", minutes, seconds)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isInteractionEnabled { return }

        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesAtLocation = nodes(at: location)

            for node in nodesAtLocation {
                if node.name == "settingsButton" {
                    saveState()
                    openSettings()
                    return
                }

                if let card = node as? SKSpriteNode, card.texture == cardBackTexture, !selectedCards.contains(card) {
                    let cardName = card.name!
                    card.texture = SKTexture(imageNamed: cardName)
                    selectedCards.append(card)

                    vibrate()

                    if selectedCards.count == 2 {
                        moves += 1
                        movesLabel.text = "Moves: \(moves)"
                        isInteractionEnabled = false

                        if selectedCards[0].name == selectedCards[1].name {
                            selectedCards.removeAll()
                            isInteractionEnabled = true
                            checkWinCondition()
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                for card in self.selectedCards {
                                    card.texture = self.cardBackTexture
                                }
                                self.selectedCards.removeAll()
                                self.isInteractionEnabled = true
                            }
                        }
                    }
                }
            }
        }
    }

    func checkWinCondition() {
        let allCardsFlipped = cards.allSatisfy { $0.texture != cardBackTexture }

        if allCardsFlipped {
            showWinScreen()
        }
    }

    func showWinScreen() {
        let elapsedTime = Date().timeIntervalSince(startTime!)
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60

        let overlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.7), size: self.size)
        overlay.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        overlay.zPosition = 9
        addChild(overlay)

        let youWinNode = SKSpriteNode(imageNamed: "Youwin")
        youWinNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 170)
        youWinNode.zPosition = 10
        youWinNode.setScale(0.3)
        addChild(youWinNode)

        let movesFrame = SKSpriteNode(imageNamed: "Frame_2")
        movesFrame.size = CGSize(width: 230, height: 70)
        movesFrame.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 30)
        movesFrame.zPosition = 9
        addChild(movesFrame)

        let movesLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        movesLabel.text = "Moves: \(moves)"
        movesLabel.fontSize = 35
        movesLabel.position = CGPoint(x: 0, y: -10)
        movesLabel.zPosition = 10
        movesLabel.fontColor = .white
        movesFrame.addChild(movesLabel)

        let timeFrame = SKSpriteNode(imageNamed: "Frame_2")
        timeFrame.size = CGSize(width: 300, height: 70)
        timeFrame.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 50)
        timeFrame.zPosition = 9
        addChild(timeFrame)

        let timeLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        timeLabel.text = String(format: "Time: %d:%02d", minutes, seconds)
        timeLabel.fontSize = 35
        timeLabel.position = CGPoint(x: 0, y: -10)
        timeLabel.zPosition = 10
        timeLabel.fontColor = .white
        timeFrame.addChild(timeLabel)

        let replayButton = SKSpriteNode(imageNamed: "Replay")
        replayButton.size = CGSize(width: 100, height: 100)
        replayButton.position = CGPoint(x: self.frame.midX - 70, y: self.frame.midY - 150)
        replayButton.zPosition = 10
        replayButton.name = "replayButton"
        addChild(replayButton)

        let menuButton = SKSpriteNode(imageNamed: "Menu")
        menuButton.size = CGSize(width: 100, height: 100)
        menuButton.position = CGPoint(x: self.frame.midX + 70, y: self.frame.midY - 150)
        menuButton.zPosition = 10
        menuButton.name = "menuButton"
        addChild(menuButton)

        timer?.invalidate()

        isInteractionEnabled = false
    }

    func playSound(named soundName: String) {
        if GameSettings.shared.isSoundEnabled {
            let soundAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: false)
            self.run(soundAction)
            print("Sound played: \(soundName)")
        } else {
            print("Sound is disabled in settings")
        }
    }

    func vibrate() {
        if GameSettings.shared.isVibrationEnabled {
            if #available(iOS 10.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                print("Vibration triggered")
            }
        } else {
            print("Vibration is disabled in settings")
        }
    }

    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "cardMusic", withExtension: "mp3") else {
            print("Music not found in the bundle")
            return
        }

        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.prepareToPlay()
            backgroundMusicPlayer?.volume = 0.5
            if GameSettings.shared.isSoundEnabled {
                backgroundMusicPlayer?.play()
            }
            print("Background music started playing")
        } catch {
            print("Error playing background music: \(error.localizedDescription)")
        }
    }

    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        print("Background music stopped")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesAtLocation = nodes(at: location)

            for node in nodesAtLocation {
                if node.name == "replayButton" {
                    let newGameScene = GameScene(size: self.size)
                    newGameScene.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 1.0)
                    self.view?.presentScene(newGameScene, transition: transition)
                } else if node.name == "menuButton" {
                    let menuScene = MenuScene(size: self.size)
                    menuScene.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 1.0)
                    self.view?.presentScene(menuScene, transition: transition)
                }
            }
        }
    }

    func openSettings() {
        saveState()
        let settingsScene = SettingsScene(size: self.size)
        settingsScene.scaleMode = .aspectFill
        settingsScene.previousScene = self
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(settingsScene, transition: transition)
    }

    func resumeGame() {
        startTimer()
        isInteractionEnabled = true
    }

    func saveState() {
        
        savedState = GameState(cards: cards.map { $0.copy() as! SKSpriteNode }, selectedCards: selectedCards.map { $0.copy() as! SKSpriteNode }, moves: moves, startTime: startTime, elapsedTime: Date().timeIntervalSince(startTime!), isInteractionEnabled: isInteractionEnabled)
        timer?.invalidate()
    }

    func restoreState(_ state: GameState) {
        
        for card in cards {
            card.removeFromParent()
        }

        cards = state.cards
        selectedCards = state.selectedCards
        moves = state.moves
        startTime = state.startTime
        movesLabel.text = "Moves: \(moves)"
        timerLabel.text = String(format: "Time: %d:%02d", Int(state.elapsedTime) / 60, Int(state.elapsedTime) % 60)
        isInteractionEnabled = state.isInteractionEnabled

        for card in cards {
            addChild(card)
        }

        setupHUD()
        setupSettingsButton()
        startTimer()
        playBackgroundMusic()
    }
}

struct GameState {
    var cards: [SKSpriteNode]
    var selectedCards: [SKSpriteNode]
    var moves: Int
    var startTime: Date?
    var elapsedTime: TimeInterval
    var isInteractionEnabled: Bool
}
