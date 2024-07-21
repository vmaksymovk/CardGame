import SwiftUI
import SpriteKit

struct SpriteKitView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        
        
        let scene = LoadingScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
        
        view.ignoresSiblingOrder = true
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {}
}

#Preview {
    SpriteKitView()
}
