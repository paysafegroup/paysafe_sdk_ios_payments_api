//
//  SavedCreditCardView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct SavedCreditCardView: View {
    let savedCard: SavedCard
    let style: Style

    enum Style {
        /// Primary style
        case primary
        /// Secondary style
        case secondary

        /// Container border color
        var borderColor: Color {
            switch self {
            case .primary:
                return .ltLightPurple
            case .secondary:
                return .clear
            }
        }

        /// Horizontal padding
        var horizontalPadding: CGFloat {
            switch self {
            case .primary:
                return 25.0
            case .secondary:
                return 0.0
            }
        }
    }

    var body: some View {
        ZStack {
            containerView
            contentView
        }
    }

    private var containerView: some View {
        Rectangle()
            .foregroundColor(.ltWhite)
            .border(style.borderColor)
    }

    private var contentView: some View {
        HStack(spacing: 10) {
            cardDetailsView
            cardSecondaryDetailsView
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, style.horizontalPadding)
    }

    private var cardDetailsView: some View {
        VStack {
            HStack(spacing: 8) {
                Image("paymentMethods.creditCard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                if let brandIconName = savedCard.brandIconName {
                    Image(brandIconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 30)
                }
                PSText("*\(savedCard.lastDigits)")
                    .font(.system(size: 17, weight: .semibold))
            }
            Spacer()
        }
    }

    private var cardSecondaryDetailsView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                PSText(savedCard.holderName)
                PSText(savedCard.expiryDateString)
            }
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(.ltDarkPurple)
        }
    }
}

struct SavedCreditCardView_Previews: PreviewProvider {
    static var previews: some View {
        let savedCard = SavedCard(
            cardBrand: .mastercard,
            lastDigits: "2476",
            holderName: "John Doe",
            expiryMonth: 9,
            expiryYear: 2028,
            singleUseCustomerToken: "singleUseCustomerToken",
            paymentTokenFrom: "paymentTokenFrom"
        )
        VStack {
            Group {
                SavedCreditCardView(
                    savedCard: savedCard,
                    style: .primary
                )
                SavedCreditCardView(
                    savedCard: savedCard,
                    style: .secondary
                )
            }
            .frame(height: 80)
            .padding(16)
        }
    }
}
