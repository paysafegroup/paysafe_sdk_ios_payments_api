//
//  DemoConfig.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCardPayments
import Foundation

enum DemoConfig {
    /// Merchant backend API key
    static let merchantBackendApiKey = FeatureData.current.merchantBackendApiKey
    /// Paysafe API key
    static let apiKey = FeatureData.current.apiKey
    /// Cards account id
    static let cardsAccountId = FeatureData.current.accountId
    /// Venmo account id
    static let venmoAccountId = FeatureData.current.accountId
    /// Venmo / Braintree profile id
    static let venmoProfileId = FeatureData.current.profileId
    /// Venmo / Braintree consumer id
    static let venmoConsumerId = FeatureData.current.consumerId
    /// Apple Pay merchant identifier
    static let applePayMerchantIdentifier = "merchant.com.paysafe.app"
    /// Customer profile id
    static let profileId = FeatureData.current.profileId
    /// Paysafe environment
    static let environment: PaysafeEnvironment = .test
}

enum FeatureData {
    struct Configuration {
        let apiKey: String
        let merchantBackendApiKey: String
        let accountId: String
        let profileId: String
        let consumerId: String
    }

    static let current: Configuration = Self.venmoDataCollectionEnabled

    static let venmoDataCollectionEnabled: Configuration = .init(
        apiKey: "T1QtOTc0NjQwOkItcWEyLTAtNjJmNTY2NTAtMC0zMDJkMDIxNDcxY2Q0Y2FlODI2MTRjZTdhZDkxMDNjNDBmNDJhYzNhMDcyYWYwZDUwMjE1MDA4NGRjYWZlM2NjYWMyMGJlNDM4MDQ5M2JlYjAxMmJjNTRlNjI2MTg1",
        merchantBackendApiKey: "",
        accountId: "1002784820",
        profileId: "1953896702662410263",
        consumerId: "consumerId+\(UUID().uuidString)"
    )

    static let venmoPrizePics: Configuration = .init(
        apiKey: "T1QtOTE0MzAwOkItcWEyLTAtNjNjODRkYjktMS0zMDJjMDIxNDQ5NzM5NTI4YmIyMWM4NWFjZWRjZWJkMmI0ODI2MjIzZjEzODcxZWEwMjE0MmE0NjQxYTU4Zjk5OTFlZDlmMDRlMDY5OTRkNTViYzk2MTBiYmZkOQ==",
        merchantBackendApiKey: "",
        accountId: "1002723680",
        profileId: "1953896702662410263",
        consumerId: "consumerId+\(UUID().uuidString)"
    )

    static let savedCards: Configuration = .init(
        apiKey: "T1QtMjE5OTUwOkItcWEyLTAtNWIzZTIwMTUtMC0zMDJjMDIxNDNmNzQ3MmFmZTQ0ZTM0NzlmZDM1MDllOTI4ZWZjZDNkMzAzMjZiNTQwMjE0MDIwZWI0MjhiODgzOGIxNzRjNTQ4OTFiMmNiYTA3N2RiNzZkMTkxOQ==",
        merchantBackendApiKey: "dGVzdF9ob3N0ZWQ6Qi1xYTItMC02MDRiM2RiNS0wLTMwMmMwMjE0N2FkYTNjYTQyMGI0N2Q4ZWI5ODEyMjYzZDQ5NGJhOTU3MTRlMTQ0ZDAyMTQwMzgyMWUzYTMzZWJmMmQwMDYyNjgyZWQwNDk1MGM3ZWJjMzE5ZmFm",
        accountId: "1001234110",
        profileId: "284f1502-0cad-4256-b5e5-705ed06cfbbd",
        consumerId: ""
    )
}
