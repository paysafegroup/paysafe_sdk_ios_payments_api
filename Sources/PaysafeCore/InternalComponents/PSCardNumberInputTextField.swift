//
//  PSCardNumberInputTextField.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

/// PSCardNumberInputTextFieldDelegate
protocol PSCardNumberInputTextFieldDelegate: AnyObject {
    /// Used when the card number input validation state is updated
    func didUpdateCardNumberInputValidationState(isValid: Bool)
    /// Used when the card number input focused state is updated
    func didUpdateCardNumberInputFocusedState(isFocused: Bool)
    /// Used when an invalid character is tried to be entered within the card number input
    func didUpdateCardNumberInputWithInvalidCharacter()
    /// Used when the card number input field value is changed
    func didUpdateCardNumberInputFieldValue()
    /// Used when the card brand is updated
    func didUpdateCardBrand(with cardBrand: PSCardBrand)
}

/// PSCardNumberInputTextField
class PSCardNumberInputTextField: PSTextField {
    /// Card number value
    private(set) var cardNumberValue: String? {
        didSet {
            psCardNumberInputTextFieldDelegate?.didUpdateCardNumberInputFieldValue()
            psCardNumberInputTextFieldDelegate?.didUpdateCardNumberInputValidationState(isValid: cardNumberValue != nil)
        }
    }

    /// PSCardNumberInputSeparatorType
    var separatorType: PSCardNumberInputSeparatorType = .whitespace {
        didSet {
            attributedText = PSCardConfiguration.makeCardNumberDisplayText(for: text, with: separatorType.separator)
            configurePlaceholders()
        }
    }

    /// PSCardBrand
    var cardBrand: PSCardBrand = .unknown {
        didSet {
            guard cardBrand != oldValue else { return }
            psCardNumberInputTextFieldDelegate?.didUpdateCardBrand(with: cardBrand)
        }
    }

    /// PSCardNumberInputTextFieldDelegate
    weak var psCardNumberInputTextFieldDelegate: PSCardNumberInputTextFieldDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textDidChange() {
        super.textDidChange()
        attributedText = PSCardConfiguration.makeCardNumberDisplayText(for: text, with: separatorType.separator)
    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let defaultCheck = super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        guard defaultCheck, let currentString = textField.text as? NSString else {
            psCardNumberInputTextFieldDelegate?.didUpdateCardNumberInputWithInvalidCharacter()
            return false
        }
        let potentialString = PSCardUtils.stripNonDigitCharacters(from: currentString.replacingCharacters(in: range, with: string))

        cardBrand = PSCardUtils.determineCardBrand(potentialString)

        let maxLengthCheck = potentialString.count <= cardBrand.cardNumberLength
        if maxLengthCheck {
            configureRightView(iconName: !potentialString.isEmpty ? cardBrand.iconName : nil)
        }
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
        let defaultPlaceholder = "Card number"
        let separator = separatorType.separator
        let selectedPlaceholder = "xxxx\(separator)xxxx\(separator)xxxx\(separator)xxxx"
        placeholders[PSTextField.PSTextFieldState.normal] = defaultPlaceholder
        placeholders[PSTextField.PSTextFieldState.selected] = selectedPlaceholder
        placeholders[PSTextField.PSTextFieldState.error] = defaultPlaceholder
    }

    /// Setup accessibility
    private func setupAccessibility() {
        accessibilityIdentifier = "cardNumberInputTextField"
    }
}

// MARK: - PSTextFieldDelegate
extension PSCardNumberInputTextField: PSTextFieldDelegate {
    func textField(_ textField: PSTextField, changed text: String?, isValid: Bool) {
        guard isValid, let text else { return cardNumberValue = nil }
        cardNumberValue = PSCardUtils.stripNonDigitCharacters(from: text)
    }

    func textField(_ textField: PSTextField, isFocused: Bool) {
        psCardNumberInputTextFieldDelegate?.didUpdateCardNumberInputFocusedState(isFocused: isFocused)
    }
}

// MARK: - PSTextFieldValidator
extension PSCardNumberInputTextField: PSTextFieldValidator {
    func validate(field: String) -> Bool {
        let cardNumber = PSCardUtils.stripNonDigitCharacters(from: field)
        return PSCardUtils.validateCardNumber(cardNumber)
    }

    func validate(characters: String) -> Bool {
        PSCardUtils.validateCardNumberCharacters(characters)
    }
}
