//
//  PSCardNumberInputSwiftUIView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafeCommon)
import PaysafeCommon
#endif
import SwiftUI

/// PSCardNumberInputSwiftUIView
public struct PSCardNumberInputSwiftUIView: UIViewRepresentable, PSCardInputView {
    /// PSCardNumberInputView
    let cardNumberView: PSCardNumberInputView

    /// - Parameters:
    ///   - separatorType: PSCardNumberInputSeparatorType, default as `whitespace`
    ///   - animateTopPlaceholderLabel: Bool, default as `true`
    ///   - hint: Placeholder for the 'selected' state. If no value is provided the default one will be set
    public init(
        separatorType: PSCardNumberInputSeparatorType = .whitespace,
        animateTopPlaceholderLabel: Bool = true,
        hint: String? = nil
    ) {
        cardNumberView = PSCardNumberInputView(
            separatorType: separatorType,
            animateTopPlaceholderLabel: animateTopPlaceholderLabel,
            hint: hint
        )
    }

    /// PSCardFieldInputEventBlock
    public var onEvent: PSCardFieldInputEventBlock? {
        didSet {
            cardNumberView.onEvent = onEvent
        }
    }

    /// PSTheme
    private var storedTheme: PSTheme = PaysafeSDK.shared.psTheme
    public var theme: PSTheme {
        get {
            storedTheme
        }
        set(theme) {
            storedTheme = theme
            cardNumberView.theme = theme
        }
    }

    /// Method that verifies if the card number input is empty
    public func isEmpty() -> Bool {
        cardNumberView.isEmpty()
    }

    /// Method that verifies if the card number input is valid
    public func isValid() -> Bool {
        cardNumberView.isValid()
    }

    /// Method that resets the theme to the initial one.
    public mutating func resetTheme() {
        theme = PaysafeSDK.shared.psTheme
    }

    /// Method that resets the card number view
    func reset() {
        cardNumberView.reset()
    }

    /// Method that returns the view's placeholder
    func getPlaceholder() -> String? {
        cardNumberView.getPlaceholder()
    }

    public func makeUIView(context: Context) -> UIView {
        cardNumberView
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        // No action required
    }
}
