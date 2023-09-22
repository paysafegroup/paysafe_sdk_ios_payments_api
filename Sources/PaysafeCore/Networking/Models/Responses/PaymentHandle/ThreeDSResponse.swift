//
//  ThreeDSResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ThreeDSResponse
struct ThreeDSResponse: Decodable {
    /// Merchant reference number
    let merchantRefNum: String?
    /// Merchant url
    let merchantUrl: String
    /// Device channel
    let deviceChannel: DeviceChannelResponse
    /// Message category
    let messageCategory: String
    /// Transaction intent
    let transactionIntent: String?
    /// Authentication purpose
    let authenticationPurpose: String
    /// Requestor challenge preference
    let requestorChallengePreference: String?
    /// User login
    let userLogin: UserLoginResponse?
    /// Order item details
    let orderItemDetails: OrderItemDetailsResponse?
    /// Purchased gitft card details
    let purchasedGiftCardDetails: PurchasedGiftCardDetailsResponse?
    /// User account details
    let userAccountDetails: UserAccountDetailsResponse?
    /// Prior 3DS authentication
    let priorThreeDSAuthentication: PriorThreeDSAuthenticationResponse?
    /// Shipping details usage
    let shippingDetailsUsage: ShippingDetailsUsageResponse?
    /// Suspicious account activity
    let suspiciousAccountActivity: Bool?
    /// Total purchases six month count
    let totalPurchasesSixMonthCount: Int?
    /// Transaction count for previous day
    let transactionCountForPreviousDay: Int?
    /// Transaction count for previous year
    let transactionCountForPreviousYear: Int?
    /// Travel details
    let travelDetails: TravelDetailsResponse?
    /// Max authorization for instalment payment
    let maxAuthorizationsForInstalmentPayment: Int?
    /// Electronic delivery
    let electronicDelivery: ElectronicDeliveryResponse?
    /// Initial purchase time
    let initialPurchaseTime: String?
}
