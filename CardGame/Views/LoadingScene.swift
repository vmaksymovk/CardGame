import Foundation
import SpriteKit

class LoadingScene: SKScene {
    let fireNode = SKSpriteNode(imageNamed: "fire")

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "BG_1")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = self.size
        background.zPosition = -1
        addChild(background)
        
        fireNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        fireNode.setScale(0.35)
        addChild(fireNode)
        
        let moveUp = SKAction.moveBy(x: 0, y: 100, duration: 1)
        let moveDown = SKAction.moveBy(x: 0, y: -100, duration: 1)
        let sequence = SKAction.sequence([moveUp, moveDown])
        let repeatAction = SKAction.repeatForever(sequence)
        
        fireNode.run(repeatAction)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.switchToMenuScene()
        }
    }
    
    func switchToMenuScene() {
        if let view = self.view {
            let transition = SKTransition.fade(withDuration: 1)
            let menuScene = MenuScene(size: self.size)
            view.presentScene(menuScene, transition: transition)
        }
    }
}
