//
//  PSCardNumberInputView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

#if canImport(PaysafeCommon)
import PaysafeCommon
#endif
import UIKit

/// PSCardNumberInputViewDelegate
protocol PSCardNumberInputViewDelegate: AnyObject {
    /// Used when the card number input validation state is updated
    func didUpdateCardNumberInputValidationState(isValid: Bool)
    /// Used when the card brand is updated
    func didUpdateCardBrand(with cardBrand: PSCardBrand)
}

/// PSCardNumberInputView
public class PSCardNumberInputView: UIView, PSCardInputView {
    /// PSCardNumberInputTextField
    lazy var cardNumberTextField: PSCardNumberInputTextField = {
        let textField = PSCardNumberInputTextField()
        textField.separatorType = separatorType
        textField.shouldAnimateTopPlaceholder = animateTopPlaceholderLabel
        textField.customLabel = customLabel
        textField.selectedPlaceholder = selectedPlaceholder
        textField.toolbarView = toolbarView
        textField.psCardNumberInputTextFieldDelegate = self
        return textField
    }()

    /// PSCardNumberInputSeparatorType
    public var separatorType: PSCardNumberInputSeparatorType = .whitespace {
        didSet {
            cardNumberTextField.separatorType = separatorType
        }
    }
    /// Indicates if the textfield should use the top placeholder animation
    private var animateTopPlaceholderLabel: Bool = true

    /// PSCardNumberInputViewDelegate
    weak var psDelegate: PSCardNumberInputViewDelegate?
    /// PSCardFieldInputEventBlock
    public var onEvent: PSCardFieldInputEventBlock?

    /// PSTheme
    private var storedTheme: PSTheme = PaysafeSDK.shared.psTheme
    /// Custom label for normal/error state (e.g. for localization). When nil, SDK default is used.
    private var customLabel: String?
    /// Placeholder for the selected state
    private var selectedPlaceholder: String?
    /// Keyboard toolbar view. When not provided defaults to `UIToolbar` with `Done` button dismissing the keyboard.
    private var toolbarView: UIView?
    /// When `false`, empty fields skip validation on blur (see `PSTextField.validatesOnBlurWhenEmpty`).
    private var validatesOnBlurWhenEmpty: Bool = true
    /// Theme
    public var theme: PSTheme {
        get {
            storedTheme
        }
        set(theme) {
            storedTheme = theme
            cardNumberTextField.theme = theme
        }
    }

    /// - Parameters:
    ///   - separatorType: PSCardNumberInputSeparatorType, default as `whitespace`
    ///   - animateTopPlaceholderLabel: Bool, default as `true`
    ///   - label: Top label and placeholder text for normal/error state (e.g. for localization). When nil, SDK default ("Card number") is used.
    ///   - hint: Placeholder for the 'selected' state. If no value is provided the default one will be set
    ///   - toolbarView: Keyboard toolbar view. When not provided defaults to `UIToolbar` with `Done` button dismissing the keyboard.
    ///   - validatesOnBlurWhenEmpty: When `false`, an empty field shows the normal border on blur instead of validating.
    public init(
        separatorType: PSCardNumberInputSeparatorType = .whitespace,
        animateTopPlaceholderLabel: Bool = true,
        label: String? = nil,
        hint: String? = nil,
        toolbarView: UIView? = nil,
        validatesOnBlurWhenEmpty: Bool = true
    ) {
        super.init(frame: .zero)
        self.animateTopPlaceholderLabel = animateTopPlaceholderLabel
        self.separatorType = separatorType
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

    /// Method that verifies if the card number input is empty
    public func isEmpty() -> Bool {
        cardNumberTextField.cardNumberValue == nil
    }

    /// Whether the field contains any raw input (including invalid partial entry).
    public func hasText() -> Bool {
        !(cardNumberTextField.text?.isEmpty ?? true)
    }

    /// Method that verifies if the card number input is valid
    public func isValid() -> Bool {
        cardNumberTextField.cardNumberValue != nil
    }

    /// Method that resets the theme to the initial one.
    public func resetTheme() {
        theme = PaysafeSDK.shared.psTheme
    }

    /// Method that resets the card number view
    func reset() {
        cardNumberTextField.resetTextField()
    }

    /// Method that returns the view's placeholder
    func getPlaceholder() -> String? {
        cardNumberTextField.placeholder
    }

    /// Configures PSCardNumberInputView
    private func configure() {
        addSubview(cardNumberTextField)
        cardNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        cardNumberTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cardNumberTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cardNumberTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cardNumberTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cardNumberTextField.validatesOnBlurWhenEmpty = validatesOnBlurWhenEmpty
    }
}

// MARK: - PSCardNumberInputTextFieldDelegate
extension PSCardNumberInputView: PSCardNumberInputTextFieldDelegate {
    func didUpdateCardNumberInputValidationState(isValid: Bool) {
        psDelegate?.didUpdateCardNumberInputValidationState(isValid: isValid)
        onEvent?(isValid ? .valid : .invalid)
    }

    func didUpdateCardNumberInputFocusedState(isFocused: Bool) {
        onEvent?(isFocused ? .focus : .blur)
    }

    func didUpdateCardNumberInputWithInvalidCharacter() {
        onEvent?(.invalidCharacter)
    }

    func didUpdateCardNumberInputFieldValue() {
        onEvent?(.fieldValueChange)
    }

    func didUpdateCardBrand(with cardBrand: PSCardBrand) {
        psDelegate?.didUpdateCardBrand(with: cardBrand)
    }
}
