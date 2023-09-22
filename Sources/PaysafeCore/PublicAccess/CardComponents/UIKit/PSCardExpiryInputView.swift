//
//  PSCardExpiryInputView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

/// PSCardExpiryInputViewDelegate
protocol PSCardExpiryInputViewDelegate: AnyObject {
    /// Used when the card expiry input validation state is updated
    func didUpdateCardExpiryInputValidationState(isValid: Bool)
}

/// PSCardExpiryInputView
public class PSCardExpiryInputView: UIView, PSCardInputView {
    /// PSCardExpiryInputTextField
    lazy var cardExpiryTextField: PSCardExpiryInputTextField = {
        let textField = PSCardExpiryInputTextField()
        textField.inputType = inputType
        textField.psCardExpiryInputTextFieldDelegate = self
        return textField
    }()

    /// PSCardExpiryInputType
    public var inputType: PSCardExpiryInputType = .datePicker {
        didSet {
            cardExpiryTextField.inputType = inputType
        }
    }

    /// PSCardExpiryInputViewDelegate
    weak var psDelegate: PSCardExpiryInputViewDelegate?
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
            cardExpiryTextField.theme = theme
        }
    }

    /// - Parameters:
    ///   - inputType: PSCardExpiryInputType, default as `datePicker`
    public init(inputType: PSCardExpiryInputType = .datePicker) {
        super.init(frame: .zero)
        self.inputType = inputType
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    /// Method that verifies if the card expiry input is empty
    public func isEmpty() -> Bool {
        cardExpiryTextField.cardExpiryDateValue == nil
    }

    /// Method that verifies if the card expiry input is valid
    public func isValid() -> Bool {
        cardExpiryTextField.cardExpiryDateValue != nil
    }

    /// Method that resets the theme to the initial one.
    public func resetTheme() {
        theme = PaysafeSDK.shared.psTheme
    }

    /// Method that resets the cardholder name view
    func reset() {
        cardExpiryTextField.resetTextField()
    }

    /// Method that returns the view's placeholder
    func getPlaceholder() -> String? {
        cardExpiryTextField.placeholder
    }

    /// Configures PSCardExpiryInputView
    private func configure() {
        addSubview(cardExpiryTextField)
        cardExpiryTextField.translatesAutoresizingMaskIntoConstraints = false
        cardExpiryTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cardExpiryTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cardExpiryTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cardExpiryTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

// MARK: - PSCardExpiryInputTextFieldDelegate
extension PSCardExpiryInputView: PSCardExpiryInputTextFieldDelegate {
    func didUpdateCardExpiryInputValidationState(isValid: Bool) {
        psDelegate?.didUpdateCardExpiryInputValidationState(isValid: isValid)
        onEvent?(isValid ? .valid : .invalid)
    }

    func didUpdateCardExpiryInputFocusedState(isFocused: Bool) {
        isFocused ? onEvent?(.focus) : nil
    }

    func didUpdateCardExpiryInputWithInvalidCharacter() {
        onEvent?(.invalidCharacter)
    }

    func didUpdateCardExpiryInputFieldValue() {
        onEvent?(.fieldValueChange)
    }
}
