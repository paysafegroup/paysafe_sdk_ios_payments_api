//
//  PSCardExpiryInputView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafeCommon)
import PaysafeCommon
#endif
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
        textField.shouldAnimateTopPlaceholder = animateTopPlaceholderLabel
        textField.selectedPlaceholder = selectedPlaceholder
        textField.psCardExpiryInputTextFieldDelegate = self
        return textField
    }()

    /// PSCardExpiryInputType
    public var inputType: PSCardExpiryInputType = .datePicker {
        didSet {
            cardExpiryTextField.inputType = inputType
        }
    }
    /// Indicates if the textfield should use the top placeholder animation
    private var animateTopPlaceholderLabel: Bool = true

    /// PSCardExpiryInputViewDelegate
    weak var psDelegate: PSCardExpiryInputViewDelegate?
    /// PSCardFieldInputEventBlock
    public var onEvent: PSCardFieldInputEventBlock?

    /// PSTheme
    private var storedTheme: PSTheme = PaysafeSDK.shared.psTheme
    /// Placeholder for the selected state
    private var selectedPlaceholder: String = "MM YY"

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
    ///   - animateTopPlaceholderLabel: Bool, default as `true`
    ///   - hint: Placeholder for the 'selected' state. If no value is provided the default one will be set
    public init(
        inputType: PSCardExpiryInputType = .datePicker,
        animateTopPlaceholderLabel: Bool = true,
        hint: String = "MM YY"
    ) {
        super.init(frame: .zero)
        self.inputType = inputType
        self.animateTopPlaceholderLabel = animateTopPlaceholderLabel
        selectedPlaceholder = hint
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
