//
//  PSCardholderNameInputSwiftUIView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

/// PSCardholderNameInputSwiftUIView
public struct PSCardholderNameInputSwiftUIView: UIViewRepresentable, PSCardInputView {
    /// PSCardholderNameInputView
    let cardholderNameView: PSCardholderNameInputView

    /// - Parameters:
    ///   - cardholderName: Cardholder name
    ///   - animateTopPlaceholderLabel: Bool, default as `true`
    ///   - hint: Placeholder for the 'selected' state. If no value is provided the default one will be set
    public init(
        cardholderName: String? = nil,
        animateTopPlaceholderLabel: Bool = true,
        hint: String = "Cardholder Name"
    ) {
        cardholderNameView = PSCardholderNameInputView(
            cardholderName: cardholderName,
            animateTopPlaceholderLabel: animateTopPlaceholderLabel,
            hint: hint
        )
    }

    /// PSCardFieldInputEventBlock
    public var onEvent: PSCardFieldInputEventBlock? {
        didSet {
            cardholderNameView.onEvent = onEvent
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
            cardholderNameView.theme = theme
        }
    }

    /// Method that verifies if the cardholder name input is empty
    public func isEmpty() -> Bool {
        cardholderNameView.isEmpty()
    }

    /// Method that verifies if the cardholder name input is valid
    public func isValid() -> Bool {
        cardholderNameView.isValid()
    }

    /// Method that resets the theme to the initial one.
    public mutating func resetTheme() {
        theme = PaysafeSDK.shared.psTheme
    }

    /// Method that resets the cardholder name input
    func reset() {
        cardholderNameView.reset()
    }

    /// Method that returns the view's placeholder
    func getPlaceholder() -> String? {
        cardholderNameView.getPlaceholder()
    }

    public func makeUIView(context: Context) -> UIView {
        cardholderNameView
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        // No action required
    }
}
