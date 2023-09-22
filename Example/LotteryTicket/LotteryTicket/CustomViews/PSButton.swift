//
//  PSButton.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct PSButton: View {
    private let title: String
    private let cornerRadius: CGFloat
    private let style: Style
    private let isEnabled: Bool
    private let isLoading: Bool
    private let action: () -> Void

    enum Style {
        /// Primary button style
        case primary
        /// Secondary button style
        case secondary
        /// Tertiary button style
        case tertiary

        /// Button foreground color
        var foregroundColor: Color {
            switch self {
            case .primary:
                return .ltWhite
            case .secondary:
                return .ltPurple
            case .tertiary:
                return .ltPurple
            }
        }

        /// Button background color
        var backgroundColor: Color {
            switch self {
            case .primary:
                return .ltPurple
            case .secondary:
                return .ltWhite
            case .tertiary:
                return .ltWhite
            }
        }

        /// Button border color
        var borderColor: Color {
            switch self {
            case .primary:
                return .clear
            case .secondary:
                return .ltPurple
            case .tertiary:
                return .clear
            }
        }

        /// Button border width
        var borderWidth: CGFloat {
            switch self {
            case .primary:
                return 0
            case .secondary:
                return 1
            case .tertiary:
                return 0
            }
        }
    }

    init(
        title: String,
        cornerRadius: CGFloat = 25,
        style: Style,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.cornerRadius = cornerRadius
        self.style = style
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            buttonLabel
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }

    private var buttonLabel: some View {
        Group {
            if isLoading {
                loadingView
            } else {
                textView
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(style.backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(style.borderColor, lineWidth: style.borderWidth)
        )
    }

    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
            .scaleEffect(1.5)
    }

    private var textView: some View {
        Text(title)
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(style.foregroundColor)
    }
}

struct PSButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            PSButton(title: "Primary button", style: .primary) {}
            PSButton(title: "Secondary button", style: .secondary) {}
        }
        .padding()
    }
}
