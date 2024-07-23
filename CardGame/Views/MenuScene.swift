import Foundation
import SpriteKit
import UIKit
import SafariServices
import SwiftUI

class MenuScene: SKScene {

    override func didMove(to view: SKView) {
        // Добавляем фон
        let background = SKSpriteNode(imageNamed: "BG_1")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = self.size
        background.zPosition = -1
        addChild(background)
        
        // Добавляем изображение "Menu_icon"
        let menuIcon = SKSpriteNode(imageNamed: "Menu_icon")
        menuIcon.size = CGSize(width: 300, height: 300)
        menuIcon.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100) // Позиционируем изображение немного выше центра
        menuIcon.zPosition = 1
        addChild(menuIcon)
        
        // Добавляем кнопку "Play Now"
        let playButton = SKSpriteNode(imageNamed: "PlayButton1")
        playButton.name = "playButton"
        playButton.size = CGSize(width: 300, height: 70) // Установите размер в соответствии с вашим изображением
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100) // Позиционируем кнопку под изображением
        playButton.zPosition = 1
        addChild(playButton)
        
        // Добавляем кнопку "Privacy Policy"
        let privacyButton = SKSpriteNode(imageNamed: "PrivatePolicy")
        privacyButton.name = "privacyButton"
        privacyButton.size = CGSize(width: 250, height: 60) // Установите размер в соответствии с вашим изображением
        privacyButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200) // Позиционируем кнопку ниже кнопки "Play Now"
        privacyButton.zPosition = 1
        addChild(privacyButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesArray = self.nodes(at: location)
            
            for node in nodesArray {
                if node.name == "playButton" {
                    let gameScene = GameScene(size: self.size)
                    let transition = SKTransition.fade(withDuration: 1)
                    self.view?.presentScene(gameScene, transition: transition)
                } else if node.name == "privacyButton" {
                    if let viewController = self.view?.window?.rootViewController {
                        let safariVC = SFSafariViewController(url: URL(string: "https://www.linkedin.com/in/vladyslav-maksymov/")!)
                        viewController.present(safariVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
