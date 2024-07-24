import Foundation
import SpriteKit

class SettingsScene: SKScene {
    var previousScene: GameScene?
    
override func didMove(to view: SKView) {
        backgroundColor = .clear

        let frameNode = SKSpriteNode(imageNamed: "Frame_2")
        frameNode.size = CGSize(width: 400, height: 400)
        frameNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        frameNode.zPosition = 1
        addChild(frameNode)

        let verticalSpacing: CGFloat = 20

        let resumeFrame = SKSpriteNode(imageNamed: "Frame_3")
        resumeFrame.size = CGSize(width: 200, height: 50)
        resumeFrame.position = CGPoint(x: 0, y: 60 + verticalSpacing)
        resumeFrame.zPosition = 2
        frameNode.addChild(resumeFrame)

        let resumeButton = SKLabelNode(text: "Resume")
        resumeButton.name = "resumeButton"
        resumeButton.fontSize = 30
        resumeButton.fontColor = .white
        resumeButton.fontName = "Helvetica-Bold"
        resumeButton.position = CGPoint(x: 0, y: -10)
        resumeButton.zPosition = 3
        resumeFrame.addChild(resumeButton)

        let mainMenuFrame = SKSpriteNode(imageNamed: "Frame_3")
        mainMenuFrame.size = CGSize(width: 200, height: 50)
        mainMenuFrame.position = CGPoint(x: 0, y: 10)
        mainMenuFrame.zPosition = 2
        frameNode.addChild(mainMenuFrame)

        let mainMenuButton = SKLabelNode(text: "Main Menu")
        mainMenuButton.name = "mainMenuButton"
        mainMenuButton.fontSize = 30
        mainMenuButton.fontColor = .white
        mainMenuButton.fontName = "Helvetica-Bold"
        mainMenuButton.position = CGPoint(x: 0, y: -10)
        mainMenuButton.zPosition = 3
        mainMenuFrame.addChild(mainMenuButton)

        let soundButton = SKSpriteNode(imageNamed: GameSettings.shared.isSoundEnabled ? "Speaker" : "MuteSound")
        soundButton.name = "soundButton"
        soundButton.position = CGPoint(x: -70, y: -50 - verticalSpacing)
        soundButton.size = CGSize(width: 50, height: 50)
        soundButton.zPosition = 2
        frameNode.addChild(soundButton)

        let vibrationButton = SKSpriteNode(imageNamed: GameSettings.shared.isVibrationEnabled ? "Vibro" : "NoVibro")
        vibrationButton.name = "vibrationButton"
        vibrationButton.position = CGPoint(x: 70, y: -50 - verticalSpacing)
        vibrationButton.size = CGSize(width: 50, height: 50)
        vibrationButton.zPosition = 2
        frameNode.addChild(vibrationButton)
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesArray = self.nodes(at: location)
            
            for node in nodesArray {
                if node.name == "resumeButton" {
                    if let gameScene = previousScene {
                        gameScene.resumeGame()
                        let transition = SKTransition.fade(withDuration: 0.5)
                        self.view?.presentScene(gameScene, transition: transition)
                        gameScene.resumeFromSettings()
                    }
                }
                else if node.name == "mainMenuButton" {
                    if let gameScene = previousScene {
                        gameScene.stopBackgroundMusic()
                    }
                    let menuScene = MenuScene(size: self.size)
                    menuScene.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 1.0)
                    self.view?.presentScene(menuScene, transition: transition)
                }
                else if node.name == "soundButton" {
                    GameSettings.shared.isSoundEnabled.toggle()
                    (node as? SKSpriteNode)?.texture = SKTexture(imageNamed: GameSettings.shared.isSoundEnabled ? "Speaker" : "MuteSound")
                    if let gameScene = previousScene {
                        if GameSettings.shared.isSoundEnabled {
                            gameScene.playBackgroundMusic()
                        } else {
                            gameScene.stopBackgroundMusic()
                        }
                    }
                } else if node.name == "vibrationButton" {
                    GameSettings.shared.isVibrationEnabled.toggle()
                    (node as? SKSpriteNode)?.texture = SKTexture(imageNamed: GameSettings.shared.isVibrationEnabled ? "Vibro" : "NoVibro")
                }
            }
        }
    }




}
