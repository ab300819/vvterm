import Foundation

enum TerminalHardwareTextInputRoutingPolicy {
    static func shouldRoutePressToSystemTextInput(
        hasControlModifier: Bool,
        hasAlternateModifier: Bool,
        hasCommandModifier: Bool,
        hasActiveIMEComposition: Bool,
        isCurrentInputMethodCJK: Bool,
        isSystemTextInputToggleKey: Bool,
        hasTerminalFallbackKey: Bool,
        keyProducesText: Bool
    ) -> Bool {
        if hasControlModifier || hasAlternateModifier || hasCommandModifier {
            return false
        }
        if hasActiveIMEComposition {
            return true
        }
        if isSystemTextInputToggleKey {
            return true
        }
        if hasTerminalFallbackKey {
            return false
        }
        // When a CJK input method is active, route printable keys to the system
        // text input before composition starts — hasActiveIMEComposition only
        // becomes true after the first key has been accepted, so relying on it
        // alone leaves the first keystroke on the direct terminal path and the
        // IME never gets a chance to begin composition.
        if isCurrentInputMethodCJK && keyProducesText {
            return true
        }
        // Let UIKit own all remaining unmodified hardware text input so IMEs,
        // dead keys, and layout-specific composition can start reliably.
        let _ = keyProducesText
        return true
    }
}
