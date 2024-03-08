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
        textField.shouldAnimateTopPlaceholder = animateTopPlaceholderLabel
        textField.selectedPlaceholder = selectedPlaceholder
        return textField
    }()

    /// PSCardholderNameInputViewDelegate
    weak var psDelegate: PSCardholderNameInputViewDelegate?
    /// PSCardFieldInputEventBlock
    public var onEvent: PSCardFieldInputEventBlock?
    /// Placeholder for the selected state
    private var selectedPlaceholder: String = "Cardholder Name"
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
    /// Indicates if the textfield should use the top placeholder animation
    private var animateTopPlaceholderLabel: Bool = true

    /// - Parameters:
    ///   - cardholderName: Cardholder name
    ///   - animateTopPlaceholderLabel: Bool, default as `true`
    ///   - hint: Placeholder for the 'selected' state. If no value is provided the default one will be set
    public init(
        cardholderName: String? = nil,
        animateTopPlaceholderLabel: Bool = true,
        hint: String = "Cardholder Name"
    ) {
        super.init(frame: .zero)
        self.animateTopPlaceholderLabel = animateTopPlaceholderLabel
        selectedPlaceholder = hint
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
