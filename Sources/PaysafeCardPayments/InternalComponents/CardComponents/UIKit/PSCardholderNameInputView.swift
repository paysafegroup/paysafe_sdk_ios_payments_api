//
//  PSCardholderNameInputView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafeCommon)
import PaysafeCommon
#endif
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
        textField.customLabel = customLabel
        textField.selectedPlaceholder = selectedPlaceholder
        textField.toolbarView = toolbarView
        return textField
    }()

    /// PSCardholderNameInputViewDelegate
    weak var psDelegate: PSCardholderNameInputViewDelegate?
    /// PSCardFieldInputEventBlock
    public var onEvent: PSCardFieldInputEventBlock?
    /// Custom label for normal/error state (e.g. for localization). When nil, SDK default is used.
    private var customLabel: String?
    /// Placeholder for the selected state
    private var selectedPlaceholder: String = "Cardholder Name"
    /// Keyboard toolbar view. When not provided defaults to `UIToolbar` with `Done` button dismissing the keyboard.
    private var toolbarView: UIView?
    /// When `false`, empty fields skip validation on blur (see `PSTextField.validatesOnBlurWhenEmpty`).
    private var validatesOnBlurWhenEmpty: Bool = true
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
    ///   - label: Top label and placeholder text for normal/error state (e.g. for localization). When nil, SDK default ("Cardholder Name") is used.
    ///   - hint: Placeholder for the 'selected' state. If no value is provided the default one will be set
    ///   - validatesOnBlurWhenEmpty: When `false`, an empty field shows the normal border on blur instead of validating.
    public init(
        cardholderName: String? = nil,
        animateTopPlaceholderLabel: Bool = true,
        label: String? = nil,
        hint: String = "Cardholder Name",
        toolbarView: UIView? = nil,
        validatesOnBlurWhenEmpty: Bool = true
    ) {
        super.init(frame: .zero)
        self.animateTopPlaceholderLabel = animateTopPlaceholderLabel
        self.customLabel = label
        selectedPlaceholder = hint
        self.toolbarView = toolbarView
        self.validatesOnBlurWhenEmpty = validatesOnBlurWhenEmpty
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

    /// Whether the field contains any raw input (including invalid partial entry).
    public func hasText() -> Bool {
        !(cardholderNameTextField.text?.isEmpty ?? true)
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
        cardholderNameTextField.validatesOnBlurWhenEmpty = validatesOnBlurWhenEmpty
    }
}

// MARK: - PSCardholderNameInputTextFieldDelegate
extension PSCardholderNameInputView: PSCardholderNameInputTextFieldDelegate {
    func didUpdateCardholderNameInputValidationState(isValid: Bool) {
        psDelegate?.didUpdateCardholderNameInputValidationState(isValid: isValid)
        onEvent?(isValid ? .valid : .invalid)
    }

    func didUpdateCardholderNameInputFocusedState(isFocused: Bool) {
        onEvent?(isFocused ? .focus : .blur)
    }

    func didUpdateCardholderNameInputWithInvalidCharacter() {
        onEvent?(.invalidCharacter)
    }

    func didUpdateCardholderNameInputFieldValue() {
        onEvent?(.fieldValueChange)
    }
}
