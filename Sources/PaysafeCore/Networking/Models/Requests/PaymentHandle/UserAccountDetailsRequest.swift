//
//  UserAccountDetailsRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// UserAccountDetailsRequest
struct UserAccountDetailsRequest: Encodable {
    /// Created date
    let createdDate: String?
    /// Created range
    let createdRange: CreatedRangeRequest?
    /// Changed date
    let changedDate: String?
    /// Changed range
    let changedRange: ChangedRangeRequest?
    /// Password change date
    let passwordChangedDate: String?
    /// Password changed range
    let passwordChangedRange: PasswordChangeRangeRequest?
    /// Total purchases six month count
    let totalPurchasesSixMonthCount: Int?
    /// Transaction count for previous day
    let transactionCountForPreviousDay: Int?
    /// Transaction count for previous year
    let transactionCountForPreviousYear: Int?
    /// Suspicious account activity
    let suspiciousAccountActivity: Bool?
    /// Shipping details usage
    let shippingDetailsUsage: ShippingDetailsUsageRequest?
    /// Payment account details
    let paymentAccountDetails: PaymentAccountDetailsRequest?
    /// User login
    let userLogin: UserLoginRequest?
    /// Prior 3DS authentication
    let priorThreeDSAuthentication: PriorThreeDSAuthenticationRequest?
    /// Travel details
    let travelDetails: TravelDetailsRequest?
}
