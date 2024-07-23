import Foundation

class GameSettings {
    static let shared = GameSettings()
    
    var isSoundEnabled: Bool = true
    var isVibrationEnabled: Bool = true
}
