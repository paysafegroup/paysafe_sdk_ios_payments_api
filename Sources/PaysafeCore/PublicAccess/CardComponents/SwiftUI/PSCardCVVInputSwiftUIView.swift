//
//  PSCardCVVInputSwiftUIView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

/// PSCardCVVInputSwiftUIView
public struct PSCardCVVInputSwiftUIView: UIViewRepresentable, PSCardInputView {
    /// PSCardCVVInputView
    let cardCVVView: PSCardCVVInputView

    /// - Parameters:
    ///   - isMasked: Boolean indicating if the text should be of type .isSecureTextEntry
    ///   - cardBrand: PSCardBrand
    ///   - animateTopPlaceholderLabel: Bool, default as `true`
    ///   - hint: Placeholder for the 'selected' state. If no value is provided the default one will be set
    public init(
        isMasked: Bool = false,
        cardBrand: PSCardBrand = .unknown,
        animateTopPlaceholderLabel: Bool = true,
        hint: String = "xxx"
    ) {
        cardCVVView = PSCardCVVInputView(
            isMasked: isMasked,
            cardBrand: cardBrand,
            animateTopPlaceholderLabel: animateTopPlaceholderLabel,
            hint: hint
        )
    }

    /// PSCardFieldInputEventBlock
    public var onEvent: PSCardFieldInputEventBlock? {
        didSet {
            cardCVVView.onEvent = onEvent
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
            cardCVVView.theme = theme
        }
    }

    /// Method that verifies if the card CVV input is empty
    public func isEmpty() -> Bool {
        cardCVVView.isEmpty()
    }

    /// Method that verifies if the card CVV input is valid
    public func isValid() -> Bool {
        cardCVVView.isValid()
    }

    /// Method that resets the theme to the initial one.
    public mutating func resetTheme() {
        theme = PaysafeSDK.shared.psTheme
    }

    /// Method that resets the card CVV input
    func reset() {
        cardCVVView.reset()
    }

    /// Method that returns the view's placeholder
    func getPlaceholder() -> String? {
        cardCVVView.getPlaceholder()
    }

    public func makeUIView(context: Context) -> UIView {
        cardCVVView
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        // No action required
    }
}
