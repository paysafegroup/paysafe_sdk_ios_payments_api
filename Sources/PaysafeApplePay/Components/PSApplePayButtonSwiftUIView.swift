//
//  PSApplePayButtonSwiftUIView.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

/// PSApplePayButtonSwiftUIView
public struct PSApplePayButtonSwiftUIView: UIViewRepresentable {
    /// PSApplePayButtonView
    let paymentButtonView: PSApplePayButtonView

    /// - Parameters:
    ///   - buttonType: ButtonType
    ///   - buttonStyle: ButtonStyle
    ///   - action: Action closure
    public init(
        buttonType: PSApplePayButtonView.ButtonType,
        buttonStyle: PSApplePayButtonView.ButtonStyle,
        action: (() -> Void)?
    ) {
        paymentButtonView = PSApplePayButtonView(
            buttonType: buttonType,
            buttonStyle: buttonStyle,
            action: action
        )
    }

    public func makeUIView(context: Context) -> UIView {
        paymentButtonView
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        // No action required
    }
}
