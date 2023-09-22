//
//  ThreeDsRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ThreeDSRequest
struct ThreeDSRequest: Encodable {
    /// Merchant reference number
    let merchantRefNum: String?
    /// Merchant url
    let merchantUrl: String
    /// Device channel
    let deviceChannel: DeviceChannelRequest
    /// Message category
    let messageCategory: MessageCategoryRequest
    /// Transaction intent
    let transactionIntent: TransactionIntentRequest?
    /// Authentication purpose
    let authenticationPurpose: AuthenticationPurposeRequest
    /// Requestor challenge preference
    let requestorChallengePreference: RequestorChallengePreferenceRequest?
    /// User login
    let userLogin: UserLoginRequest?
    /// Order item details
    let orderItemDetails: OrderItemDetailsRequest?
    /// Purchased gitft card details
    let purchasedGiftCardDetails: PurchasedGiftCardDetailsRequest?
    /// User account details
    let userAccountDetails: UserAccountDetailsRequest?
    /// Prior 3DS authentication
    let priorThreeDSAuthentication: PriorThreeDSAuthenticationRequest?
    /// Shipping details usage
    let shippingDetailsUsage: ShippingDetailsUsageRequest?
    /// Suspicious account activity
    let suspiciousAccountActivity: Bool?
    /// Total purchases six month count
    let totalPurchasesSixMonthCount: Int?
    /// Transaction count for previous day
    let transactionCountForPreviousDay: Int?
    /// Transaction count for previous year
    let transactionCountForPreviousYear: Int?
    /// Travel details
    let travelDetails: TravelDetailsRequest?
    /// Max authorization for instalment payment
    let maxAuthorizationsForInstalmentPayment: Int?
    /// Electronic delivery
    let electronicDelivery: ElectronicDeliveryRequest?
    /// Initial purchase time
    let initialPurchaseTime: String?
}
