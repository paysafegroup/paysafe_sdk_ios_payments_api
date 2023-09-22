//
//  PSApplePayButtonView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PassKit
import UIKit

/// PSApplePayButtonView
public class PSApplePayButtonView: UIView {
    /// PKPaymentButton
    lazy var paymentButton: PKPaymentButton = {
        PKPaymentButton(
            paymentButtonType: buttonType.toPKPaymentButtonType,
            paymentButtonStyle: buttonStyle.toPKPaymentButtonStyle
        )
    }()

    /// Available PKPaymentButton types
    public enum ButtonType {
        /// Buy type
        case buy
        /// Donate type
        case donate

        /// PKPaymentButtonType
        var toPKPaymentButtonType: PKPaymentButtonType {
            switch self {
            case .buy:
                return .buy
            case .donate:
                return .donate
            }
        }
    }

    /// Available PKPaymentButton styles
    public enum ButtonStyle {
        /// White button style
        case white
        /// White outline button style
        case whiteOutline
        /// Black button style
        case black
        /// Automatic button style
        case automatic

        /// PKPaymentButtonStyle
        var toPKPaymentButtonStyle: PKPaymentButtonStyle {
            switch self {
            case .white:
                return .white
            case .whiteOutline:
                return .whiteOutline
            case .black:
                return .black
            case .automatic:
                return .automatic
            }
        }
    }

    /// PaymentButtonView ButtonType
    let buttonType: ButtonType
    /// PaymentButtonView ButtonStyle
    let buttonStyle: ButtonStyle
    /// Action closure
    let action: (() -> Void)?

    /// - Parameters:
    ///   - buttonType: ButtonType
    ///   - buttonStyle: ButtonStyle
    ///   - action: Action closure
    public init(
        buttonType: ButtonType,
        buttonStyle: ButtonStyle,
        action: (() -> Void)?
    ) {
        self.buttonType = buttonType
        self.buttonStyle = buttonStyle
        self.action = action
        super.init(frame: .zero)
        addSubview(paymentButton)
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        paymentButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        paymentButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        paymentButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        paymentButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        paymentButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func handleTap() {
        action?()
    }
}
