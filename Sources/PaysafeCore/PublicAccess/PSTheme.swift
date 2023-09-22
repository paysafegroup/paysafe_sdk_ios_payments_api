//
//  PSTheme.swift
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

/// PSTheme used for styling Paysafe components
public struct PSTheme: Equatable {
    /// Card component background color
    public var backgroundColor: UIColor
    /// Card component border color in default state
    public var borderColor: UIColor
    /// Card component border color in focused/selected state
    public var focusedBorderColor: UIColor
    /// Card component border corner radius
    public var borderCornerRadius: CGFloat
    /// Card component border and top & centered placeholder color for invalid/error state
    public var errorColor: UIColor
    /// Card component text input color
    public var textInputColor: UIColor
    /// Card component top & centered placeholder color
    public var placeholderColor: UIColor
    /// Card component hint/mask color
    public var hintColor: UIColor
    /// Card component text input font
    public var textInputFont: UIFont
    /// Card component top & centered placeholder font (top placeholder size decreases automatically)
    public var placeholderFont: UIFont
    /// Card component hint/mask font
    public var hintFont: UIFont

    /// - Parameters:
    ///   - backgroundColor: Card component background color
    ///   - borderColor: Card component border color in default state
    ///   - focusedBorderColor: Card component border color in focused/selected state
    ///   - borderCornerRadius: Card component border corner radius
    ///   - errorColor: Card component border and top placeholder color for invalid/error state
    ///   - textInputColor: Card component text input color
    ///   - placeholderColor: Card component top & centered placeholder color
    ///   - hintColor: Card component hint/mask color
    ///   - textInputFont: Card component text input font
    ///   - placeholderFont: Card component top & centered placeholder font
    ///   - hintFont: Card component hint/mask font
    public init(
        backgroundColor: UIColor? = nil,
        borderColor: UIColor? = nil,
        focusedBorderColor: UIColor? = nil,
        borderCornerRadius: CGFloat? = nil,
        errorColor: UIColor? = nil,
        textInputColor: UIColor? = nil,
        placeholderColor: UIColor? = nil,
        hintColor: UIColor? = nil,
        textInputFont: UIFont? = nil,
        placeholderFont: UIFont? = nil,
        hintFont: UIFont? = nil
    ) {
        self.backgroundColor = backgroundColor ?? .defaultBackgroundColor
        self.borderColor = borderColor ?? .defaultBorderColor
        self.focusedBorderColor = focusedBorderColor ?? .defaultFocusedBorderColor
        self.borderCornerRadius = borderCornerRadius ?? .zero
        self.errorColor = errorColor ?? .defaultErrorColor
        self.textInputColor = textInputColor ?? .defaultTextInputColor
        self.placeholderColor = placeholderColor ?? .defaultPlaceholderColor
        self.hintColor = hintColor ?? .defaultHintColor
        self.textInputFont = textInputFont ?? .defaultTextInputFont
        self.placeholderFont = placeholderFont ?? .defaultPlaceholderFont
        self.hintFont = hintFont ?? .defaultHintFont
    }
}

// MARK: - Default theme colors
private extension UIColor {
    /// Default background color
    static let defaultBackgroundColor = UIColor(
        dynamicProvider: { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            default:
                return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
        }
    )

    /// Default border color
    static let defaultBorderColor = UIColor(
        dynamicProvider: { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor(red: 120 / 255, green: 120 / 255, blue: 120 / 255, alpha: 1.0)
            default:
                return UIColor(red: 211 / 255, green: 211 / 255, blue: 211 / 255, alpha: 1.0)
            }
        }
    )

    /// Default focused border color
    static let defaultFocusedBorderColor = UIColor(
        dynamicProvider: { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            default:
                return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
    )

    /// Default error color
    static let defaultErrorColor = UIColor(
        dynamicProvider: { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            default:
                return UIColor(red: 170 / 255, green: 0.0, blue: 0.0, alpha: 1.0)
            }
        }
    )

    /// Default text input color
    static let defaultTextInputColor = UIColor(
        dynamicProvider: { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            default:
                return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
    )

    /// Default placeholder color
    static let defaultPlaceholderColor = UIColor(
        dynamicProvider: { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            default:
                return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
    )

    /// Default hint color
    static let defaultHintColor = UIColor(
        dynamicProvider: { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 1.0)
            default:
                return UIColor(red: 211 / 255, green: 211 / 255, blue: 211 / 255, alpha: 1.0)
            }
        }
    )
}

// MARK: - Default theme fonts
private extension UIFont {
    /// Default text input font
    static let defaultTextInputFont: UIFont = .systemFont(ofSize: 16, weight: .regular)
    /// Default placeholder font
    static let defaultPlaceholderFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
    /// Default hint font
    static let defaultHintFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
}
