//
//  PaymentManager.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCardPayments
import SwiftUI

/// PaymentManager
final class PaymentManager {
    /// Paysafe API key
    let apiKey = ""
    /// Paysafe Card payments account id
    let cardAccountId = ""
    /// Paysafe Venmo payments account id
    let venmoAccountId = ""

    /// Setup Paysafe SDK.
    func setupPaysafeSDK() {
        let theme = PSTheme(
            backgroundColor: .ltWhite,
            borderColor: .ltLightPurple,
            focusedBorderColor: .ltDarkPurple,
            textInputColor: .ltDarkPurple,
            placeholderColor: .ltDarkPurple,
            hintColor: .ltPalePurple
        )
        
        PaysafeSDK.shared.setup(
            apiKey: apiKey,
            environment: .test,
            theme: theme
        ) { result in
            switch result {
            case .success:
                print("[Paysafe SDK] initialized successfully")
            case let .failure(error):
                print("[Paysafe SDK] initialize failure \(error.displayMessage)")
            }
        }
    }
}
