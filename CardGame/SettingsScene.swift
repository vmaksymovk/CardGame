import Foundation
import SpriteKit

class SettingsScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .gray
        
        let soundLabel = SKLabelNode(text: "Sound")
        soundLabel.name = "soundLabel"
        soundLabel.fontSize = 45
        soundLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 50)
        addChild(soundLabel)
        
        let vibrationLabel = SKLabelNode(text: "Vibration")
        vibrationLabel.name = "vibrationLabel"
        vibrationLabel.fontSize = 45
        vibrationLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 50)
        addChild(vibrationLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesArray = self.nodes(at: location)
            
            for node in nodesArray {
                if node.name == "soundLabel" {
                    // Переключение звука
                } else if node.name == "vibrationLabel" {
                    // Переключение вибрации
                }
            }
        }
    }
}
