//
//  PSCardCVVInputTextField.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

/// PSCardCVVInputTextFieldDelegate
protocol PSCardCVVInputTextFieldDelegate: AnyObject {
    /// Used when the card CVV input validation state is updated
    func didUpdateCardCVVInputValidationState(isValid: Bool)
    /// Used when the card CVV input focused state is updated
    func didUpdateCardCVVInputFocusedState(isFocused: Bool)
    /// Used when an invalid character is tried to be entered within the card CVV input
    func didUpdateCardCVVInputWithInvalidCharacter()
    /// Used when the card CVV input field value is changed
    func didUpdateCardCVVInputFieldValue()
}

/// PSCardCVVInputTextField
class PSCardCVVInputTextField: PSTextField {
    /// Card CVV value
    private(set) var cardCVVValue: String? {
        didSet {
            psCardCVVInputTextFieldDelegate?.didUpdateCardCVVInputFieldValue()
            psCardCVVInputTextFieldDelegate?.didUpdateCardCVVInputValidationState(isValid: cardCVVValue != nil)
        }
    }
    /// Default placeholder for the selected state
    var selectedPlaceholder: String = "xxx" {
        didSet {
            updateSelectedPlaceholder(selectedPlaceholder)
        }
    }

    /// PSCardBrand
    var cardBrand: PSCardBrand = .unknown {
        didSet {
            guard let newText = text?.prefix(cardBrand.cvvLength) else { return }
            text = String(newText)
            configurePlaceholders()
        }
    }

    /// PSCardCVVInputTextFieldDelegate
    weak var psCardCVVInputTextFieldDelegate: PSCardCVVInputTextFieldDelegate?

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
            psCardCVVInputTextFieldDelegate?.didUpdateCardCVVInputWithInvalidCharacter()
            return false
        }
        let potentialString = currentString.replacingCharacters(in: range, with: string)
        let maxLengthCheck = potentialString.count <= cardBrand.cvvLength
        return maxLengthCheck
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        super.canPerformAction(action, withSender: sender) && action == #selector(paste(_:))
    }

    private func configure() {
        validator = self
        psDelegate = self
        keyboardType = .numberPad
        configurePlaceholders()
        setupAccessibility()
    }

    /// Configures placeholders for normal, selected and error state
    private func configurePlaceholders() {
        let defaultPlaceholder = "CVV"
        placeholders[PSTextField.PSTextFieldState.normal] = defaultPlaceholder
        placeholders[PSTextField.PSTextFieldState.selected] = selectedPlaceholder
        placeholders[PSTextField.PSTextFieldState.error] = defaultPlaceholder
    }

    private func updateSelectedPlaceholder(_ value: String) {
        placeholders[PSTextField.PSTextFieldState.selected] = value
    }

    /// Setup accessibility
    private func setupAccessibility() {
        accessibilityIdentifier = "cardCVVInputTextField"
    }
}

// MARK: - PSTextFieldDelegate
extension PSCardCVVInputTextField: PSTextFieldDelegate {
    func textField(_ textField: PSTextField, changed text: String?, isValid: Bool) {
        cardCVVValue = isValid ? text : nil
    }

    func textField(_ textField: PSTextField, isFocused: Bool) {
        psCardCVVInputTextFieldDelegate?.didUpdateCardCVVInputFocusedState(isFocused: isFocused)
    }
}

// MARK: - PSTextFieldValidator
extension PSCardCVVInputTextField: PSTextFieldValidator {
    func validate(field: String) -> Bool {
        PSCardValidator.validCVVCheck(field, and: cardBrand)
    }

    func validate(characters: String) -> Bool {
        guard !characters.isEmpty else { return true }
        return PSCardValidator.validCVVCharactersCheck(characters)
    }
}
