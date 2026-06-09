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
        textField.customLabel = customLabel
        textField.selectedPlaceholder = selectedPlaceholder
        textField.toolbarView = toolbarView
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
    /// Custom label for normal/error state (e.g. for localization). When nil, SDK default is used.
    private var customLabel: String?
    /// Placeholder for the selected state
    private var selectedPlaceholder: String = "MM YY"
    /// Keyboard toolbar view. When not provided defaults to `UIToolbar` with `Done` button dismissing the keyboard.
    private var toolbarView: UIView?
    /// When `false`, empty fields skip validation on blur (see `PSTextField.validatesOnBlurWhenEmpty`).
    private var validatesOnBlurWhenEmpty: Bool = true

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
    ///   - label: Top label and placeholder text for normal/error state (e.g. for localization). When nil, SDK default ("Expiry Date") is used.
    ///   - hint: Placeholder for the 'selected' state. If no value is provided the default one will be set
    ///   - toolbarView: Keyboard toolbar view. When not provided defaults to `UIToolbar` with `Done` button dismissing the keyboard.
    ///   - validatesOnBlurWhenEmpty: When `false`, an empty field shows the normal border on blur instead of validating.
    public init(
        inputType: PSCardExpiryInputType = .datePicker,
        animateTopPlaceholderLabel: Bool = true,
        label: String? = nil,
        hint: String = "MM YY",
        toolbarView: UIView? = nil,
        validatesOnBlurWhenEmpty: Bool = true
    ) {
        super.init(frame: .zero)
        self.inputType = inputType
        self.animateTopPlaceholderLabel = animateTopPlaceholderLabel
        self.customLabel = label
        selectedPlaceholder = hint
        self.toolbarView = toolbarView
        self.validatesOnBlurWhenEmpty = validatesOnBlurWhenEmpty

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

    /// Whether the field contains any raw input (including invalid partial entry).
    public func hasText() -> Bool {
        !(cardExpiryTextField.text?.isEmpty ?? true)
    }

    /// Method that verifies if the card expiry input is valid
    public func isValid() -> Bool {
        cardExpiryTextField.cardExpiryDateValue != nil
    }

    /// Method that resets the theme to the initial one.
    public func resetTheme() {
        theme = PaysafeSDK.shared.psTheme
    }

    /// Method that resets the card expiry view
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
        cardExpiryTextField.validatesOnBlurWhenEmpty = validatesOnBlurWhenEmpty
    }
}

// MARK: - PSCardExpiryInputTextFieldDelegate
extension PSCardExpiryInputView: PSCardExpiryInputTextFieldDelegate {
    func didUpdateCardExpiryInputValidationState(isValid: Bool) {
        psDelegate?.didUpdateCardExpiryInputValidationState(isValid: isValid)
        onEvent?(isValid ? .valid : .invalid)
    }

    func didUpdateCardExpiryInputFocusedState(isFocused: Bool) {
        onEvent?(isFocused ? .focus : .blur)
    }

    func didUpdateCardExpiryInputWithInvalidCharacter() {
        onEvent?(.invalidCharacter)
    }

    func didUpdateCardExpiryInputFieldValue() {
        onEvent?(.fieldValueChange)
    }
}
