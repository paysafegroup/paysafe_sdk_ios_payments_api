//
//  PSCardExpiryInputTextField.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

/// PSCardExpiryInputTextFieldDelegate
protocol PSCardExpiryInputTextFieldDelegate: AnyObject {
    /// Used when the card expiry input validation state is updated
    func didUpdateCardExpiryInputValidationState(isValid: Bool)
    /// Used when the card expiry input focused state is updated
    func didUpdateCardExpiryInputFocusedState(isFocused: Bool)
    /// Used when an invalid character is tried to be entered within the card expiry input
    func didUpdateCardExpiryInputWithInvalidCharacter()
    /// Used when the card expiry input field value is changed
    func didUpdateCardExpiryInputFieldValue()
}

/// PSCardExpiryInputTextField
class PSCardExpiryInputTextField: PSTextField {
    /// Card expiry date value: month and year
    private(set) var cardExpiryDateValue: (month: Int, year: Int)? {
        didSet {
            psCardExpiryInputTextFieldDelegate?.didUpdateCardExpiryInputFieldValue()
            psCardExpiryInputTextFieldDelegate?.didUpdateCardExpiryInputValidationState(isValid: cardExpiryDateValue != nil)
        }
    }
    /// Default placeholder for the selected state
    var selectedPlaceholder: String = "MM  YY" {
        didSet {
            updateSelectedPlaceholder(selectedPlaceholder)
        }
    }

    /// PSCardExpiryInputType
    var inputType: PSCardExpiryInputType = .text {
        didSet {
            configureInputView()
        }
    }

    /// Expiry date picker view
    private lazy var expiryDatePickerView: PSExpiryPickerView = {
        let pickerView = PSExpiryPickerView()
        pickerView.psDelegate = self
        return pickerView
    }()

    /// PSCardExpiryInputTextFieldDelegate
    weak var psCardExpiryInputTextFieldDelegate: PSCardExpiryInputTextFieldDelegate?

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
        attributedText = PSCardConfiguration.makeCardExpiryDateDisplayText(for: text)
    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let defaultCheck = super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        guard defaultCheck, let currentString = textField.text as? NSString else {
            psCardExpiryInputTextFieldDelegate?.didUpdateCardExpiryInputWithInvalidCharacter()
            return false
        }
        let potentialString = currentString.replacingCharacters(in: range, with: string)
        let maxLengthCheck = potentialString.count <= 7
        return maxLengthCheck
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
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
        let defaultPlaceholder = "Expiry Date"
        placeholders[PSTextField.PSTextFieldState.normal] = defaultPlaceholder
        placeholders[PSTextField.PSTextFieldState.selected] = selectedPlaceholder
        placeholders[PSTextField.PSTextFieldState.error] = defaultPlaceholder
    }

    private func updateSelectedPlaceholder(_ value: String) {
        placeholders[PSTextField.PSTextFieldState.selected] = value
    }

    /// Setup accessibility
    private func setupAccessibility() {
        accessibilityIdentifier = "cardExpiryInputTextField"
    }

    private func configureInputView() {
        inputView = inputType == .datePicker ? expiryDatePickerView : nil
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        inputType == .datePicker ? CGRect.zero : super.caretRect(for: position)
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        inputType == .datePicker ? [] : super.selectionRects(for: range)
    }

    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        guard case .datePicker = inputType else { return }
        expiryDatePickerView.didBeginEditing()
    }
}

// MARK: - PSExpiryPickerViewDelegate
extension PSCardExpiryInputTextField: PSExpiryPickerViewDelegate {
    func pickerViewSelectedDate(month: Int, year: Int) {
        cardExpiryDateValue = (month, year)
        text = String(format: "%02d / %02d", month, year % 100)
    }
}

// MARK: - PSTextFieldDelegate
extension PSCardExpiryInputTextField: PSTextFieldDelegate {
    func textField(_ textField: PSTextField, changed text: String?, isValid: Bool) {
        guard isValid,
              let text,
              let month = Int(text.prefix(2)),
              let year = Int(text.suffix(2)) else {
            cardExpiryDateValue = nil
            return
        }
        cardExpiryDateValue = (month, PSCardUtils.determineFullExpiryYear(from: year))
    }

    func textField(_ textField: PSTextField, isFocused: Bool) {
        psCardExpiryInputTextFieldDelegate?.didUpdateCardExpiryInputFocusedState(isFocused: isFocused)
    }
}

// MARK: - PSTextFieldValidator
extension PSCardExpiryInputTextField: PSTextFieldValidator {
    func validate(field: String) -> Bool {
        PSCardUtils.validateExpiryDate(field)
    }

    func validate(characters: String) -> Bool {
        guard case .text = inputType else { return false }
        return PSCardUtils.validateExpiryDateCharacters(characters)
    }
}
