//
//  ThreeDS.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Public object avaialble for the merchant when used for the tokenization
/// maxAuthorizationsForInstalmentPayment is required when authenticationPurpose = INSTALMENT_TRANSACTION.
public struct ThreeDS: Encodable {
    /// Merchant url
    let merchantUrl: String
    /// Use 3DS version 2
    var useThreeDSecureVersion2: Bool?
    /// Authentication purpose
    var authenticationPurpose: AuthenticationPurpose
    /// Process
    public let process: Bool?
    /// Max authorizations for instalment payment
    let maxAuthorizationsForInstalmentPayment: Int?
    /// Billing cycle
    let billingCycle: BillingCycle?
    /// Electronic delivery
    let electronicDelivery: ElectronicDelivery?
    /// Profile
    let profile: ThreeDSProfile?
    /// Message category
    let messageCategory: MessageCategory
    /// Requestor challenge preference
    let requestorChallengePreference: RequestorChallengePreference?
    /// User login
    let userLogin: UserLogin?
    /// Transaction intent
    let transactionIntent: TransactionIntent
    /// Initial purchase time
    let initialPurchaseTime: String?
    /// Order item details
    let orderItemDetails: OrderItemDetails?
    /// Purchased gift card details
    let purchasedGiftCardDetails: PurchasedGiftCardDetails?
    /// User account details
    let userAccountDetails: UserAccountDetails?
    /// Prior 3DS authentication
    let priorThreeDSAuthentication: PriorThreeDSAuthentication?
    /// Shipping details usage
    let shippingDetailsUsage: ShippingDetailsUsage?
    /// Suspicious account activity
    let suspiciousAccountActivity: Bool?
    /// Total purchases six month count
    let totalPurchasesSixMonthCount: Int?
    /// Transaction count for previous day
    let transactionCountForPreviousDay: Int?
    /// Transaction count for previous year
    let transactionCountForPreviousYear: Int?
    /// Travel details
    let travelDetails: TravelDetails?

    /// - Parameters:
    ///   - merchantUrl: Merchant url
    ///   - useThreeDSecureVersion2: Use 3DS version 2
    ///   - authenticationPurpose: Authentication purpose
    ///   - maxAuthorizationsForInstalmentPayment: Max authorizations for instalment payment
    ///   - billingCycle: Billing cycle
    ///   - electronicDelivery: Electronic delivery
    ///   - profile: Profile
    ///   - messageCategory: Message category
    ///   - requestorChallengePreference: Requestor challenge preference
    ///   - userLogin: User login details
    ///   - transactionIntent: Transaction intent
    ///   - initialPurchaseTime: Initial purchase time
    ///   - orderItemDetails: Order item details
    ///   - purchasedGiftCardDetails: Purchased gift card details
    ///   - userAccountDetails: User account details
    ///   - priorThreeDSAuthentication: Prior threeDS authentication
    ///   - shippingDetailsUsage: Shipping details usage
    ///   - suspiciousAccountActivity: Suspicious account activity
    ///   - totalPurchasesSixMonthCount: Total purchases during six month
    ///   - transactionCountForPreviousDay: Transaction count for previous day
    ///   - transactionCountForPreviousYear: Transaction count for previous year
    ///   - travelDetails: Travel details
    public init(
        merchantUrl: String,
        useThreeDSecureVersion2: Bool? = nil,
        authenticationPurpose: AuthenticationPurpose = .paymentTransaction,
        process: Bool? = nil,
        maxAuthorizationsForInstalmentPayment: Int? = nil,
        billingCycle: BillingCycle? = nil,
        electronicDelivery: ElectronicDelivery? = nil,
        profile: ThreeDSProfile? = nil,
        messageCategory: MessageCategory = .payment,
        requestorChallengePreference: RequestorChallengePreference? = nil,
        userLogin: UserLogin? = nil,
        transactionIntent: TransactionIntent = .goodsOrServicePurchase,
        initialPurchaseTime: String? = nil,
        orderItemDetails: OrderItemDetails? = nil,
        purchasedGiftCardDetails: PurchasedGiftCardDetails? = nil,
        userAccountDetails: UserAccountDetails? = nil,
        priorThreeDSAuthentication: PriorThreeDSAuthentication? = nil,
        shippingDetailsUsage: ShippingDetailsUsage? = nil,
        suspiciousAccountActivity: Bool? = nil,
        totalPurchasesSixMonthCount: Int? = nil,
        transactionCountForPreviousDay: Int? = nil,
        transactionCountForPreviousYear: Int? = nil,
        travelDetails: TravelDetails? = nil
    ) {
        self.merchantUrl = merchantUrl
        self.useThreeDSecureVersion2 = useThreeDSecureVersion2
        self.authenticationPurpose = authenticationPurpose
        self.process = process
        self.maxAuthorizationsForInstalmentPayment = maxAuthorizationsForInstalmentPayment
        self.billingCycle = billingCycle
        self.electronicDelivery = electronicDelivery
        self.profile = profile
        self.messageCategory = messageCategory
        self.requestorChallengePreference = requestorChallengePreference
        self.userLogin = userLogin
        self.transactionIntent = transactionIntent
        self.initialPurchaseTime = initialPurchaseTime
        self.orderItemDetails = orderItemDetails
        self.purchasedGiftCardDetails = purchasedGiftCardDetails
        self.userAccountDetails = userAccountDetails
        self.priorThreeDSAuthentication = priorThreeDSAuthentication
        self.shippingDetailsUsage = shippingDetailsUsage
        self.suspiciousAccountActivity = suspiciousAccountActivity
        self.totalPurchasesSixMonthCount = totalPurchasesSixMonthCount
        self.transactionCountForPreviousDay = transactionCountForPreviousDay
        self.transactionCountForPreviousYear = transactionCountForPreviousYear
        self.travelDetails = travelDetails
    }

    /// Returns ThreeDSRequest based on ThreeDS object and merchant reference number.
    ///
    /// - Parameters:
    ///   - merchantRefNum: Merchant reference number
    func request(using merchantRefNum: String) -> ThreeDSRequest {
        ThreeDSRequest(
            merchantRefNum: merchantRefNum,
            merchantUrl: merchantUrl,
            messageCategory: messageCategory.request,
            transactionIntent: transactionIntent.request,
            billingCycle: billingCycle?.request,
            authenticationPurpose: authenticationPurpose.request,
            requestorChallengePreference: requestorChallengePreference?.request,
            userLogin: userLogin?.request,
            orderItemDetails: orderItemDetails?.request,
            purchasedGiftCardDetails: purchasedGiftCardDetails?.request,
            userAccountDetails: userAccountDetails?.request,
            priorThreeDSAuthentication: priorThreeDSAuthentication?.request,
            shippingDetailsUsage: shippingDetailsUsage?.request,
            suspiciousAccountActivity: suspiciousAccountActivity,
            totalPurchasesSixMonthCount: totalPurchasesSixMonthCount,
            transactionCountForPreviousDay: transactionCountForPreviousDay,
            transactionCountForPreviousYear: transactionCountForPreviousYear,
            travelDetails: travelDetails?.request,
            maxAuthorizationsForInstalmentPayment: maxAuthorizationsForInstalmentPayment,
            electronicDelivery: electronicDelivery?.request,
            initialPurchaseTime: initialPurchaseTime
        )
    }
}
