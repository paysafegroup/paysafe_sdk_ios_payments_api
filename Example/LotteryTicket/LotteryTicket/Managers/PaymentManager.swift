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
    let apiKey = "T1QtOTE0MzAwOkItcWEyLTAtNjNjODRkYjktMS0zMDJjMDIxNDQ5NzM5NTI4YmIyMWM4NWFjZWRjZWJkMmI0ODI2MjIzZjEzODcxZWEwMjE0MmE0NjQxYTU4Zjk5OTFlZDlmMDRlMDY5OTRkNTViYzk2MTBiYmZkOQ=="
    /// Paysafe Card payments account id
    let cardAccountId = ""
    /// Paysafe Venmo payments account id
    let venmoAccountId = "1002723680"

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
