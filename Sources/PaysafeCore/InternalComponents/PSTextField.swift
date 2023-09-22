//
//  PSTextField.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

/// PSTextFieldDelegate
protocol PSTextFieldDelegate: AnyObject {
    func textField(_ textField: PSTextField, changed text: String?, isValid: Bool)
    func textField(_ textField: PSTextField, isFocused: Bool)
}

/// PSTextField
class PSTextField: UITextField {
    /// Top placeholder label
    private var topPlaceholderLabel: UILabel?
    /// Top placeholder label vertical constraint
    private var topPlaceholderLabelVerticalConstraint: NSLayoutConstraint?
    /// Top placeholder label leading constraint
    private var topPlaceholderLabelLeadingConstraint: NSLayoutConstraint?
    /// Horizontal padding
    private let horizontalPadding: CGFloat = 20.0

    /// PSTextField padding
    private var padding: UIEdgeInsets {
        let supplementaryTopPadding = frame.height * 0.25
        let topPadding = !text.isNilOrEmpty || psState == .selected ? supplementaryTopPadding : 0.0
        let rightViewWidth = rightView?.frame.width ?? 0
        return UIEdgeInsets(
            top: topPadding,
            left: horizontalPadding,
            bottom: 0,
            right: horizontalPadding + rightViewWidth
        )
    }

    /// Possible text field states: normal, selected and error
    enum PSTextFieldState {
        /// Normal, unselected textfield state
        case normal
        /// Selected textfield state
        case selected
        /// Invalid textfield state
        case error
    }

    /// PSTextFieldState
    private var psState: PSTextFieldState = .normal {
        didSet {
            updateAppearance()
        }
    }

    /// PSTheme
    private var storedTheme: PSTheme = PaysafeSDK.shared.psTheme
    var theme: PSTheme {
        get {
            storedTheme
        }
        set(theme) {
            storedTheme = theme
            applyTheme()
        }
    }

    /// PSTextFieldValidator
    var validator: PSTextFieldValidator?
    /// PSTextFieldDelegate
    weak var psDelegate: PSTextFieldDelegate?

    /// Determines the placeholder color based on state.
    private var placeholderColor: UIColor {
        switch psState {
        case .normal:
            return theme.placeholderColor
        case .selected:
            return theme.hintColor
        case .error:
            return theme.errorColor
        }
    }

    /// Determines the placeholder font based on state.
    private var placeholderFont: UIFont {
        switch psState {
        case .normal:
            return theme.placeholderFont
        case .selected:
            return theme.hintFont
        case .error:
            return theme.placeholderFont
        }
    }

    /// Placeholders dictionary for normal, selected and error state
    var placeholders: [PSTextFieldState: String] = [:] {
        didSet {
            guard let normalPlaceholder = placeholders[.normal] else { return }
            placeholder = normalPlaceholder
            topPlaceholderLabel?.text = normalPlaceholder
        }
    }

    /// Text alignment
    override var textAlignment: NSTextAlignment {
        didSet {
            if textAlignment == .center {
                topPlaceholderLabelLeadingConstraint?.isActive = false
            }
        }
    }

    /// Valid state
    var isValid: Bool = true {
        didSet {
            switch isValid {
            case true:
                psState = isEditing ? .selected : .normal
            case false:
                psState = .error
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyTheme()
    }

    func configureRightView(iconName: String?) {
        guard let iconName else { return rightView = nil }
        rightView = UIImageView(image: UIImage(named: iconName, in: Bundle.module, compatibleWith: nil))
        rightViewMode = .always
        layoutIfNeeded()
    }

    @objc
    func textDidChange() {
        guard let text else { return }
        isValid = true
        animateTopPlaceholderLabel(visible: psState == .selected)
        psDelegate?.textField(self, changed: text, isValid: validator?.validate(field: text) ?? false)
    }

    func resetTextField() {
        text?.removeAll()
        psDelegate?.textField(self, changed: "", isValid: false)
        isValid = true
        rightView = nil
    }

    func applyTheme() {
        backgroundColor = theme.backgroundColor
        font = theme.textInputFont
        textColor = theme.textInputColor
        layer.cornerRadius = theme.borderCornerRadius
        topPlaceholderLabel?.textColor = theme.placeholderColor
        topPlaceholderLabel?.font = theme.placeholderFont.withSize(placeholderFont.pointSize - 2)
        updateAppearance()
    }
}

// MARK: - Private
private extension PSTextField {
    func configure() {
        configureTopPlaceholderLabel()
        configureTextField()
        configureToolbarButton()
        applyTheme()
        layer.borderWidth = 1
    }

    func configureTextField() {
        autocorrectionType = .no
        borderStyle = .none
        delegate = self
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    func updateAppearance() {
        switch psState {
        case .normal:
            placeholder = placeholders[.normal]
            animateTopPlaceholderLabel(visible: !text.isNilOrEmpty)
            topPlaceholderLabel?.textColor = theme.placeholderColor
            layer.borderColor = theme.borderColor.cgColor
        case .selected:
            placeholder = placeholders[.selected]
            animateTopPlaceholderLabel(visible: true)
            topPlaceholderLabel?.textColor = theme.placeholderColor
            layer.borderColor = theme.focusedBorderColor.cgColor
        case .error:
            placeholder = placeholders[.error]
            animateTopPlaceholderLabel(visible: !text.isNilOrEmpty)
            topPlaceholderLabel?.textColor = theme.errorColor
            layer.borderColor = theme.errorColor.cgColor
        }
        updatePlaceholderAttributes()
    }

    func updatePlaceholderAttributes() {
        guard let placeholder else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: placeholderColor,
                NSAttributedString.Key.font: placeholderFont,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
    }

    func configureTopPlaceholderLabel() {
        let topPlaceholderLabel = UILabel(frame: .zero)
        addSubview(topPlaceholderLabel)
        self.topPlaceholderLabel = topPlaceholderLabel

        topPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        let topPlaceholderLabelVerticalConstraint = topPlaceholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        let topPlaceholderLabelLeadingConstraint = topPlaceholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        NSLayoutConstraint.activate([
            topPlaceholderLabelLeadingConstraint,
            topPlaceholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            topPlaceholderLabelVerticalConstraint
        ])
        self.topPlaceholderLabelVerticalConstraint = topPlaceholderLabelVerticalConstraint
        self.topPlaceholderLabelLeadingConstraint = topPlaceholderLabelLeadingConstraint

        topPlaceholderLabel.isHidden = true
        topPlaceholderLabel.alpha = 0
    }

    func animateTopPlaceholderLabel(visible: Bool) {
        // Check if it's already in the desired state
        guard visible == topPlaceholderLabel?.isHidden else { return }
        isEditing ? layoutIfNeeded() : nil

        topPlaceholderLabel?.alpha = visible ? 0 : 1
        topPlaceholderLabel?.isHidden = false

        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                guard let self else { return }
                let supplementaryTopPadding = -frame.height * 0.15
                self.topPlaceholderLabelVerticalConstraint?.constant = visible ? supplementaryTopPadding : 0.0
                self.topPlaceholderLabel?.alpha = visible ? 1 : 0
                self.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                guard let self else { return }
                self.topPlaceholderLabel?.isHidden = !visible
            }
        )
    }

    func configureToolbarButton() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(toolbarButtonAction))
        ]
        toolbar.sizeToFit()
        inputAccessoryView = toolbar
    }

    @objc
    func toolbarButtonAction() {
        resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension PSTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return textField.text?.last != " "
        }
        return validator?.validate(characters: string) ?? false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        psState = .selected
        psDelegate?.textField(self, isFocused: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text else { return }
        isValid = validator?.validate(field: text) ?? false
        psDelegate?.textField(self, isFocused: false)
    }
}

// MARK: - Rect
extension PSTextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= padding.right - rect.width - 4
        return rect
    }
}
