//
//  UserAccountDetailsResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// UserAccountDetailsResponse
struct UserAccountDetailsResponse: Decodable {
    /// Created date
    let createdDate: String?
    /// Created range
    let createdRange: CreatedRangeResponse?
    /// Changed date
    let changedDate: String?
    /// Changed range
    let changedRange: ChangedRangeResponse?
    /// Password change date
    let passwordChangedDate: String?
    /// Password changed range
    let passwordChangedRange: PasswordChangeRangeResponse?
    /// Total purchases six month count
    let totalPurchasesSixMonthCount: Int?
    /// Transaction count for previous day
    let transactionCountForPreviousDay: Int?
    /// Transaction count for previous year
    let transactionCountForPreviousYear: Int?
    /// Suspicious account activity
    let suspiciousAccountActivity: Bool?
    /// Shipping details usage
    let shippingDetailsUsage: ShippingDetailsUsageResponse?
    /// Payment account details
    let paymentAccountDetails: PaymentAccountDetailsResponse?
    /// User login
    let userLogin: UserLoginResponse?
    /// Prior 3DS authentication
    let priorThreeDSAuthentication: PriorThreeDSAuthenticationResponse?
    /// Travel details
    let travelDetails: TravelDetailsResponse?
}
