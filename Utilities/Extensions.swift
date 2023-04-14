import AVFoundation
import SwiftUI

public extension AVPlayer {
    static let sharedDingPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "gong", withExtension: "wav") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
}

public extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

public extension TextField {
    func formFieldStyle() -> some View {
        return self.modifier(FormTextField())
    }
}

public struct FormTextField: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .autocorrectionDisabled(true)
            .keyboardType(.alphabet)
            .submitLabel(.done)
    }
}
