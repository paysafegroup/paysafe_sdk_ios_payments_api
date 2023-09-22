//
//  PaymentManager.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCore
import SwiftUI

/// PaymentManager
final class PaymentManager {
    /// Paysafe API key
    let apiKey = "T1QtMjE5OTUwOkItcWEyLTAtNWIzZTIwMTUtMC0zMDJjMDIxNDNmNzQ3MmFmZTQ0ZTM0NzlmZDM1MDllOTI4ZWZjZDNkMzAzMjZiNTQwMjE0MDIwZWI0MjhiODgzOGIxNzRjNTQ4OTFiMmNiYTA3N2RiNzZkMTkxOQ=="
    /// Paysafe Card payments account id
    let cardAccountId = "1001234110"
    /// Paysafe PayPal payments account id
    let paypalAccountId = "1002720380"

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
