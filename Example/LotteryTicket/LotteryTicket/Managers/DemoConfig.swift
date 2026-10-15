//
//  DemoConfig.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCardPayments

enum DemoConfig {
    /// Merchant backend API key
    static let merchantBackendApiKey = ""
    /// Paysafe API key
    static let apiKey = ""
    /// Cards account id
    static let cardsAccountId = ""
    /// Venmo account id
    static let venmoAccountId = ""
    /// Venmo / Braintree profile id
    static let venmoProfileId = ""
    /// Apple Pay merchant identifier
    static let applePayMerchantIdentifier = "merchant.com.paysafe.app"
    /// Customer profile id
    static let profileId = ""
    /// Paysafe environment
    static let environment: PaysafeEnvironment = .test
}
