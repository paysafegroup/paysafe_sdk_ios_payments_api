//
//  PSCardholderNameInputView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

/// PSCardholderNameInputViewDelegate
protocol PSCardholderNameInputViewDelegate: AnyObject {
    /// Used when the cardholder name input validation state is updated
    func didUpdateCardholderNameInputValidationState(isValid: Bool)
}

/// PSCardholderNameInputView
public class PSCardholderNameInputView: UIView, PSCardInputView {
    /// PSCardholderNameInputTextField
    lazy var cardholderNameTextField: PSCardholderNameInputTextField = {
        let textField = PSCardholderNameInputTextField()
        textField.psCardholderNameInputTextFieldDelegate = self
        return textField
    }()

    /// PSCardholderNameInputViewDelegate
    weak var psDelegate: PSCardholderNameInputViewDelegate?
    /// PSCardFieldInputEventBlock
    public var onEvent: PSCardFieldInputEventBlock?

    /// PSTheme
    private var storedTheme: PSTheme = PaysafeSDK.shared.psTheme
    public var theme: PSTheme {
        get {
            storedTheme
        }
        set(theme) {
            storedTheme = theme
            cardholderNameTextField.theme = theme
        }
    }

    /// - Parameters:
    ///   - cardholderName: Cardholder name
    public init(cardholderName: String? = nil) {
        super.init(frame: .zero)
        cardholderNameTextField.cardholderNameValue = cardholderName
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    /// Method that verifies if the cardholder name input is empty
    public func isEmpty() -> Bool {
        cardholderNameTextField.cardholderNameValue == nil
    }

    /// Method that verifies if the cardholder name input is valid
    public func isValid() -> Bool {
        cardholderNameTextField.cardholderNameValue != nil
    }

    /// Method that resets the theme to the initial one.
    public func resetTheme() {
        theme = PaysafeSDK.shared.psTheme
    }

    /// Method that resets the cardholder name view
    func reset() {
        cardholderNameTextField.resetTextField()
    }

    /// Method that returns the view's placeholder
    func getPlaceholder() -> String? {
        cardholderNameTextField.placeholder
    }

    /// Configures PSCardholderNameInputView
    private func configure() {
        addSubview(cardholderNameTextField)
        cardholderNameTextField.translatesAutoresizingMaskIntoConstraints = false
        cardholderNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cardholderNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cardholderNameTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cardholderNameTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

// MARK: - PSCardholderNameInputTextFieldDelegate
extension PSCardholderNameInputView: PSCardholderNameInputTextFieldDelegate {
    func didUpdateCardholderNameInputValidationState(isValid: Bool) {
        psDelegate?.didUpdateCardholderNameInputValidationState(isValid: isValid)
        onEvent?(isValid ? .valid : .invalid)
    }

    func didUpdateCardholderNameInputFocusedState(isFocused: Bool) {
        isFocused ? onEvent?(.focus) : nil
    }

    func didUpdateCardholderNameInputWithInvalidCharacter() {
        onEvent?(.invalidCharacter)
    }

    func didUpdateCardholderNameInputFieldValue() {
        onEvent?(.fieldValueChange)
    }
}
