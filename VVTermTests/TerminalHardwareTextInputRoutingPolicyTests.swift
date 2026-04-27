import Testing
@testable import VVTerm

struct TerminalHardwareTextInputRoutingPolicyTests {
    @Test
    func routesPrintablePinyinKeysToSystemTextInput() {
        #expect(
            TerminalHardwareTextInputRoutingPolicy.shouldRoutePressToSystemTextInput(
                hasControlModifier: false,
                hasAlternateModifier: false,
                hasCommandModifier: false,
                hasActiveIMEComposition: false,
                isCurrentInputMethodCJK: true,
                isSystemTextInputToggleKey: false,
                hasTerminalFallbackKey: false,
                keyProducesText: true
            )
        )
    }

    @Test
    func routesPrintableKanaKeysToSystemTextInput() {
        #expect(
            TerminalHardwareTextInputRoutingPolicy.shouldRoutePressToSystemTextInput(
                hasControlModifier: false,
                hasAlternateModifier: false,
                hasCommandModifier: false,
                hasActiveIMEComposition: false,
                isCurrentInputMethodCJK: true,
                isSystemTextInputToggleKey: false,
                hasTerminalFallbackKey: false,
                keyProducesText: true
            )
        )
    }

    @Test
    func routesPrintableHangulKeysToSystemTextInput() {
        #expect(
            TerminalHardwareTextInputRoutingPolicy.shouldRoutePressToSystemTextInput(
                hasControlModifier: false,
                hasAlternateModifier: false,
                hasCommandModifier: false,
                hasActiveIMEComposition: false,
                isCurrentInputMethodCJK: true,
                isSystemTextInputToggleKey: false,
                hasTerminalFallbackKey: false,
                keyProducesText: true
            )
        )
    }

    @Test
    func routesLatinPrintableKeysToSystemTextInput() {
        #expect(
            TerminalHardwareTextInputRoutingPolicy.shouldRoutePressToSystemTextInput(
                hasControlModifier: false,
                hasAlternateModifier: false,
                hasCommandModifier: false,
                hasActiveIMEComposition: false,
                isCurrentInputMethodCJK: false,
                isSystemTextInputToggleKey: false,
                hasTerminalFallbackKey: false,
                keyProducesText: true
            )
        )
    }

    @Test
    func keepsTerminalFallbackKeysOffSystemTextInputEvenInCJKLayouts() {
        #expect(
            TerminalHardwareTextInputRoutingPolicy.shouldRoutePressToSystemTextInput(
                hasControlModifier: false,
                hasAlternateModifier: false,
                hasCommandModifier: false,
                hasActiveIMEComposition: false,
                isCurrentInputMethodCJK: true,
                isSystemTextInputToggleKey: false,
                hasTerminalFallbackKey: true,
                keyProducesText: true
            ) == false
        )
    }

    @Test
    func routesCapsLockToggleToSystemTextInputEvenThoughItIsFallbackKey() {
        #expect(
            TerminalHardwareTextInputRoutingPolicy.shouldRoutePressToSystemTextInput(
                hasControlModifier: false,
                hasAlternateModifier: false,
                hasCommandModifier: false,
                hasActiveIMEComposition: false,
                isCurrentInputMethodCJK: false,
                isSystemTextInputToggleKey: true,
                hasTerminalFallbackKey: true,
                keyProducesText: false
            )
        )
    }

    @Test
    func alwaysRoutesActiveCompositionThroughSystemTextInput() {
        #expect(
            TerminalHardwareTextInputRoutingPolicy.shouldRoutePressToSystemTextInput(
                hasControlModifier: false,
                hasAlternateModifier: false,
                hasCommandModifier: false,
                hasActiveIMEComposition: true,
                isCurrentInputMethodCJK: false,
                isSystemTextInputToggleKey: false,
                hasTerminalFallbackKey: true,
                keyProducesText: false
            )
        )
    }

    @Test
    func keepsModifiedPrintableKeysOnDirectGhosttyPath() {
        #expect(
            TerminalHardwareTextInputRoutingPolicy.shouldRoutePressToSystemTextInput(
                hasControlModifier: true,
                hasAlternateModifier: false,
                hasCommandModifier: false,
                hasActiveIMEComposition: false,
                isCurrentInputMethodCJK: false,
                isSystemTextInputToggleKey: false,
                hasTerminalFallbackKey: false,
                keyProducesText: true
            ) == false
        )
        #expect(
            TerminalHardwareTextInputRoutingPolicy.shouldRoutePressToSystemTextInput(
                hasControlModifier: false,
                hasAlternateModifier: true,
                hasCommandModifier: false,
                hasActiveIMEComposition: false,
                isCurrentInputMethodCJK: false,
                isSystemTextInputToggleKey: false,
                hasTerminalFallbackKey: false,
                keyProducesText: true
            ) == false
        )
        #expect(
            TerminalHardwareTextInputRoutingPolicy.shouldRoutePressToSystemTextInput(
                hasControlModifier: false,
                hasAlternateModifier: false,
                hasCommandModifier: true,
                hasActiveIMEComposition: false,
                isCurrentInputMethodCJK: false,
                isSystemTextInputToggleKey: false,
                hasTerminalFallbackKey: false,
                keyProducesText: true
            ) == false
        )
    }

    @Test
    func modifierKeysTakePriorityOverCJKLayout() {
        // Lock the policy ordering: even with a CJK input method active,
        // modifier-bearing keystrokes (Ctrl-/, Cmd-V, Alt-arrow, etc.) must
        // stay on the direct ghostty path so terminal shortcuts never get
        // captured by the system IME.
        #expect(
            TerminalHardwareTextInputRoutingPolicy.shouldRoutePressToSystemTextInput(
                hasControlModifier: true,
                hasAlternateModifier: false,
                hasCommandModifier: false,
                hasActiveIMEComposition: false,
                isCurrentInputMethodCJK: true,
                isSystemTextInputToggleKey: false,
                hasTerminalFallbackKey: false,
                keyProducesText: true
            ) == false
        )
        #expect(
            TerminalHardwareTextInputRoutingPolicy.shouldRoutePressToSystemTextInput(
                hasControlModifier: false,
                hasAlternateModifier: true,
                hasCommandModifier: false,
                hasActiveIMEComposition: false,
                isCurrentInputMethodCJK: true,
                isSystemTextInputToggleKey: false,
                hasTerminalFallbackKey: false,
                keyProducesText: true
            ) == false
        )
        #expect(
            TerminalHardwareTextInputRoutingPolicy.shouldRoutePressToSystemTextInput(
                hasControlModifier: false,
                hasAlternateModifier: false,
                hasCommandModifier: true,
                hasActiveIMEComposition: false,
                isCurrentInputMethodCJK: true,
                isSystemTextInputToggleKey: false,
                hasTerminalFallbackKey: false,
                keyProducesText: true
            ) == false
        )
    }
}

struct TerminalKeyboardFocusPolicyTests {
    @Test
    func startsAutomaticWithoutReconnectRestore() {
        let policy = TerminalKeyboardFocusPolicy()

        #expect(policy.allowsAutomaticFocus)
        #expect(policy.shouldRestoreOnReconnect == false)
    }

    @Test
    func userDismissalDisablesAutomaticFocusUntilExplicitRefocus() {
        var policy = TerminalKeyboardFocusPolicy()

        policy.requestFocus()
        policy.dismissForUser()

        #expect(policy.allowsAutomaticFocus == false)
        #expect(policy.shouldRestoreOnReconnect == false)

        policy.requestFocus()

        #expect(policy.allowsAutomaticFocus)
        #expect(policy.shouldRestoreOnReconnect)
    }

    @Test
    func reconnectRestoreReEnablesAutomaticFocusAfterManualDismissal() {
        var policy = TerminalKeyboardFocusPolicy()

        policy.dismissForUser()
        policy.markForReconnect()

        #expect(policy.allowsAutomaticFocus)
        #expect(policy.shouldRestoreOnReconnect)
    }

    @Test
    func clearingReconnectIntentPreservesFocusMode() {
        var policy = TerminalKeyboardFocusPolicy()

        policy.requestFocus()
        policy.clearReconnect()

        #expect(policy.allowsAutomaticFocus)
        #expect(policy.shouldRestoreOnReconnect == false)

        policy.dismissForUser()
        policy.clearReconnect()

        #expect(policy.allowsAutomaticFocus == false)
        #expect(policy.shouldRestoreOnReconnect == false)
    }
}
