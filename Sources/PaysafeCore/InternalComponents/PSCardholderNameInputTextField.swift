//
//  PSCardholderNameInputTextField.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

/// PSCardholderNameInputTextFieldDelegate
protocol PSCardholderNameInputTextFieldDelegate: AnyObject {
    /// Used when the cardholder name input validation state is updated
    func didUpdateCardholderNameInputValidationState(isValid: Bool)
    /// Used when the cardholder name input focused state is updated
    func didUpdateCardholderNameInputFocusedState(isFocused: Bool)
    /// Used when an invalid character is tried to be entered within the cardholder name input
    func didUpdateCardholderNameInputWithInvalidCharacter()
    /// Used when the cardholder name input field value is changed
    func didUpdateCardholderNameInputFieldValue()
}

/// PSCardholderNameInputTextField
class PSCardholderNameInputTextField: PSTextField {
    /// Cardholder name value
    var cardholderNameValue: String? {
        didSet {
            psCardholderNameInputTextFieldDelegate?.didUpdateCardholderNameInputFieldValue()
            psCardholderNameInputTextFieldDelegate?.didUpdateCardholderNameInputValidationState(isValid: cardholderNameValue != nil)
        }
    }

    /// PSCardholderNameInputTextFieldDelegate
    weak var psCardholderNameInputTextFieldDelegate: PSCardholderNameInputTextFieldDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let defaultCheck = super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        guard defaultCheck, let currentString = textField.text as? NSString else {
            psCardholderNameInputTextFieldDelegate?.didUpdateCardholderNameInputWithInvalidCharacter()
            return false
        }
        let potentialString = currentString.replacingCharacters(in: range, with: string)
        let maxLenghtCheck = potentialString.count <= 24
        return maxLenghtCheck
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        super.canPerformAction(action, withSender: sender) && action == #selector(paste(_:))
    }

    private func configure() {
        validator = self
        psDelegate = self
        keyboardType = .asciiCapable
        autocapitalizationType = .words
        configurePlaceholders()
        setupAccessibility()
    }

    /// Configures placeholders for normal, selected and error state
    private func configurePlaceholders() {
        let defaultPlaceholder = "Cardholder Name"
        placeholders[PSTextField.PSTextFieldState.normal] = defaultPlaceholder
        placeholders[PSTextField.PSTextFieldState.selected] = defaultPlaceholder
        placeholders[PSTextField.PSTextFieldState.error] = defaultPlaceholder
    }

    /// Setup accessibility
    private func setupAccessibility() {
        accessibilityIdentifier = "cardholderNameInputTextField"
    }
}

// MARK: - PSTextFieldDelegate
extension PSCardholderNameInputTextField: PSTextFieldDelegate {
    func textField(_ textField: PSTextField, changed text: String?, isValid: Bool) {
        cardholderNameValue = isValid ? text : nil
    }

    func textField(_ textField: PSTextField, isFocused: Bool) {
        psCardholderNameInputTextFieldDelegate?.didUpdateCardholderNameInputFocusedState(isFocused: isFocused)
    }
}

// MARK: - PSTextFieldValidator
extension PSCardholderNameInputTextField: PSTextFieldValidator {
    func validate(field: String) -> Bool {
        PSCardValidator.validCardholderNameCheck(field)
    }

    func validate(characters: String) -> Bool {
        guard !characters.isEmpty else { return true }
        return PSCardValidator.validCardholderNameCharactersCheck(characters)
    }
}
