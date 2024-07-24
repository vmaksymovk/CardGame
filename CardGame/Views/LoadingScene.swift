import Foundation
import SpriteKit

class LoadingScene: SKScene {
    let fireNode = SKSpriteNode(imageNamed: "fire")
    let starsBackground = SKSpriteNode(imageNamed: "Stars")
    let cherry = SKSpriteNode(imageNamed: "Cherry")
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "BG_1")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = self.size
        background.zPosition = -2
        addChild(background)
        
       
        starsBackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        starsBackground.size = self.size
        starsBackground.zPosition = -1
        addChild(starsBackground)
        
        
        fireNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        fireNode.setScale(0.35)
        fireNode.zPosition = 1
        addChild(fireNode)
        
       
        let moveUp = SKAction.moveBy(x: 0, y: 100, duration: 1)
        let moveDown = SKAction.moveBy(x: 0, y: -100, duration: 1)
        let sequence = SKAction.sequence([moveUp, moveDown])
        let repeatAction = SKAction.repeatForever(sequence)
        fireNode.run(repeatAction)
        
        cherry.size = CGSize(width: 150, height: 150)
        cherry.position = CGPoint(x: self.frame.maxX - cherry.size.width/2 - 30, y: self.frame.maxY - cherry.size.height/2 - 120)
                cherry.zPosition = 2
                addChild(cherry)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
