import Foundation
import SpriteKit
import UIKit
import SafariServices
import SwiftUI

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        // Установка фона BG_1
        let background = SKSpriteNode(imageNamed: "BG_1")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = self.size
        background.zPosition = -1
        addChild(background)
        
        let playButton = SKLabelNode(text: "Play Now")
        playButton.name = "playButton"
        playButton.fontSize = 45
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 50)
        addChild(playButton)
        
        let privacyButton = SKLabelNode(text: "Privacy Policy")
        privacyButton.name = "privacyButton"
        privacyButton.fontSize = 45
        privacyButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 50)
        addChild(privacyButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesArray = self.nodes(at: location)
            
            for node in nodesArray {
                if node.name == "playButton" {
                    // Переход к игре
                    let gameScene = GameScene(size: self.size)
                    let transition = SKTransition.fade(withDuration: 1)
                    self.view?.presentScene(gameScene, transition: transition)
                } else if node.name == "privacyButton" {
                    // Открытие Privacy Policy
                    if let viewController = self.view?.window?.rootViewController {
                        let safariVC = SFSafariViewController(url: URL(string: "https://www.linkedin.com/in/vladyslav-maksymov/")!)
                        viewController.present(safariVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
