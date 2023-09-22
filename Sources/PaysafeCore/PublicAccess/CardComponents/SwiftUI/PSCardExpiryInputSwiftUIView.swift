//
//  PSCardExpiryInputSwiftUIView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

/// PSCardExpiryInputSwiftUIView
public struct PSCardExpiryInputSwiftUIView: UIViewRepresentable, PSCardInputView {
    /// PSCardExpiryInputView
    let cardExpiryView: PSCardExpiryInputView

    /// - Parameters:
    ///   - inputType: PSCardExpiryInputType, default as `datePicker`
    ///   - animateTopPlaceholderLabel: Bool, default as `true`
    public init(
        inputType: PSCardExpiryInputType = .datePicker,
        animateTopPlaceholderLabel: Bool = true
    ) {
        cardExpiryView = PSCardExpiryInputView(
            inputType: inputType,
            animateTopPlaceholderLabel: animateTopPlaceholderLabel
        )
    }

    /// PSCardFieldInputEventBlock
    public var onEvent: PSCardFieldInputEventBlock? {
        didSet {
            cardExpiryView.onEvent = onEvent
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
            cardExpiryView.theme = theme
        }
    }

    /// Method that verifies if the card expiry input is empty
    public func isEmpty() -> Bool {
        cardExpiryView.isEmpty()
    }

    /// Method that verifies if the card expiry input is valid
    public func isValid() -> Bool {
        cardExpiryView.isValid()
    }

    /// Method that resets the theme to the initial one.
    public mutating func resetTheme() {
        theme = PaysafeSDK.shared.psTheme
    }

    /// Method that resets the card expiry input
    func reset() {
        cardExpiryView.reset()
    }

    /// Method that returns the view's placeholder
    func getPlaceholder() -> String? {
        cardExpiryView.getPlaceholder()
    }

    public func makeUIView(context: Context) -> UIView {
        cardExpiryView
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        // No action required
    }
}
