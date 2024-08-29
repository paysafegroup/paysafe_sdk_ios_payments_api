//
//  PSCardCVVInputView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit
#if canImport(PaysafeCommon)
import PaysafeCommon
#endif


/// PSCardCVVInputViewDelegate
protocol PSCardCVVInputViewDelegate: AnyObject {
    /// Used when the CVV input validation state is updated
    func didUpdateCardCVVInputValidationState(isValid: Bool)
}

/// PSCardCVVInputView
public class PSCardCVVInputView: UIView, PSCardInputView {
    /// PSCardCVVInputTextField
    lazy var cardCVVTextField: PSCardCVVInputTextField = {
        let textField = PSCardCVVInputTextField()
        textField.isSecureTextEntry = isMasked
        textField.cardBrand = cardBrand
        textField.shouldAnimateTopPlaceholder = animateTopPlaceholderLabel
        textField.selectedPlaceholder = selectedPlaceholder
        textField.psCardCVVInputTextFieldDelegate = self
        return textField
    }()

    /// Boolean indicating if the text should be of type .isSecureTextEntry
    public var isMasked: Bool = false {
        didSet {
            cardCVVTextField.isSecureTextEntry = isMasked
        }
    }
    /// Indicates if the textfield should use the top placeholder animation
    private var animateTopPlaceholderLabel: Bool = true
    /// Placeholder for the selected state
    private var selectedPlaceholder: String = "xxx"
    /// PSCardBrand
    public var cardBrand: PSCardBrand = .unknown {
        didSet {
            cardCVVTextField.cardBrand = cardBrand
        }
    }

    /// PSCardCVVInputViewDelegate
    weak var psDelegate: PSCardCVVInputViewDelegate?
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
            cardCVVTextField.theme = theme
        }
    }

    /// - Parameters:
    ///   - isMasked: Boolean indicating if the text should be of type .isSecureTextEntry, default as `false`
    ///   - cardBrand: PSCardBrand, default as `unknown`
    ///   - animateTopPlaceholderLabel: Bool, default as `true`
    ///   - hint: Placeholder for the 'selected' state. If no value is provided the default one will be set
    public init(
        isMasked: Bool = false,
        cardBrand: PSCardBrand = .unknown,
        animateTopPlaceholderLabel: Bool = true,
        hint: String = "xxx"
    ) {
        super.init(frame: .zero)
        self.isMasked = isMasked
        self.cardBrand = cardBrand
        self.animateTopPlaceholderLabel = animateTopPlaceholderLabel
        selectedPlaceholder = hint
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    /// Method that verifies if the card CVV input is empty
    public func isEmpty() -> Bool {
        cardCVVTextField.cardCVVValue == nil
    }

    /// Method that verifies if the card CVV input is valid
    public func isValid() -> Bool {
        cardCVVTextField.cardCVVValue != nil
    }

    /// Method that resets the theme to the initial one.
    public func resetTheme() {
        theme = PaysafeSDK.shared.psTheme
    }

    /// Method that resets the cardholder name view
    func reset() {
        cardCVVTextField.resetTextField()
    }

    /// Method that returns the view's placeholder
    func getPlaceholder() -> String? {
        cardCVVTextField.placeholder
    }

    /// Configures PSCardCVVInputView
    private func configure() {
        addSubview(cardCVVTextField)
        cardCVVTextField.translatesAutoresizingMaskIntoConstraints = false
        cardCVVTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cardCVVTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cardCVVTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cardCVVTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

// MARK: - PSCardCVVInputTextFieldDelegate
extension PSCardCVVInputView: PSCardCVVInputTextFieldDelegate {
    func didUpdateCardCVVInputValidationState(isValid: Bool) {
        psDelegate?.didUpdateCardCVVInputValidationState(isValid: isValid)
        onEvent?(isValid ? .valid : .invalid)
    }

    func didUpdateCardCVVInputFocusedState(isFocused: Bool) {
        isFocused ? onEvent?(.focus) : nil
    }

    func didUpdateCardCVVInputWithInvalidCharacter() {
        onEvent?(.invalidCharacter)
    }

    func didUpdateCardCVVInputFieldValue() {
        onEvent?(.fieldValueChange)
    }
}
