//
//  UserAccountDetails.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// UserAccountDetails
public struct UserAccountDetails: Encodable {
    /// Created date
    let createdDate: String?
    /// Created range
    let createdRange: CreatedRange?
    /// Changed date
    let changedDate: String?
    /// Changed range
    let changedRange: ChangedRange?
    /// Password change date
    let passwordChangedDate: String?
    /// Password changed range
    let passwordChangedRange: PasswordChangeRange?
    /// Total purchases six month count
    let totalPurchasesSixMonthCount: Int?
    /// Transaction count for previous day
    let transactionCountForPreviousDay: Int?
    /// Transaction count for previous year
    let transactionCountForPreviousYear: Int?
    /// Suspicious account activity
    let suspiciousAccountActivity: Bool?
    /// Shipping details usage
    let shippingDetailsUsage: ShippingDetailsUsage?
    /// Payment account details
    let paymentAccountDetails: PaymentAccountDetails?
    /// User login
    let userLogin: UserLogin?
    /// Prior 3DS authentication
    let priorThreeDSAuthentication: PriorThreeDSAuthentication?
    /// Travel details
    let travelDetails: TravelDetails?

    /// - Parameters:
    ///   - createdDate: Created date
    ///   - createdRange: Created range
    ///   - changedDate: Changed date
    ///   - changedRange: Changed range
    ///   - passwordChangedDate: Password change date
    ///   - passwordChangedRange: Password changed range
    ///   - totalPurchasesSixMonthCount: Total purchases six month count
    ///   - transactionCountForPreviousDay: Transaction count for previous day
    ///   - transactionCountForPreviousYear: Transaction count for previous year
    ///   - suspiciousAccountActivity: Suspicious account activity
    ///   - shippingDetailsUsage: Shipping details usage
    ///   - paymentAccountDetails: Payment account details
    ///   - userLogin: User login
    ///   - priorThreeDSAuthentication: Prior 3DS authentication
    ///   - travelDetails: Travel details
    public init(
        createdDate: String?,
        createdRange: CreatedRange?,
        changedDate: String?,
        changedRange: ChangedRange?,
        passwordChangedDate: String?,
        passwordChangedRange: PasswordChangeRange?,
        totalPurchasesSixMonthCount: Int?,
        transactionCountForPreviousDay: Int?,
        transactionCountForPreviousYear: Int?,
        suspiciousAccountActivity: Bool?,
        shippingDetailsUsage: ShippingDetailsUsage?,
        paymentAccountDetails: PaymentAccountDetails?,
        userLogin: UserLogin?,
        priorThreeDSAuthentication: PriorThreeDSAuthentication?,
        travelDetails: TravelDetails?
    ) {
        self.createdDate = createdDate
        self.createdRange = createdRange
        self.changedDate = changedDate
        self.changedRange = changedRange
        self.passwordChangedDate = passwordChangedDate
        self.passwordChangedRange = passwordChangedRange
        self.totalPurchasesSixMonthCount = totalPurchasesSixMonthCount
        self.transactionCountForPreviousDay = transactionCountForPreviousDay
        self.transactionCountForPreviousYear = transactionCountForPreviousYear
        self.suspiciousAccountActivity = suspiciousAccountActivity
        self.shippingDetailsUsage = shippingDetailsUsage
        self.paymentAccountDetails = paymentAccountDetails
        self.userLogin = userLogin
        self.priorThreeDSAuthentication = priorThreeDSAuthentication
        self.travelDetails = travelDetails
    }

    /// UserAccountDetailsRequest
    var request: UserAccountDetailsRequest {
        UserAccountDetailsRequest(
            createdDate: createdDate,
            createdRange: createdRange?.request,
            changedDate: changedDate,
            changedRange: changedRange?.request,
            passwordChangedDate: passwordChangedDate,
            passwordChangedRange: passwordChangedRange?.request,
            totalPurchasesSixMonthCount: totalPurchasesSixMonthCount,
            transactionCountForPreviousDay: transactionCountForPreviousDay,
            transactionCountForPreviousYear: transactionCountForPreviousYear,
            suspiciousAccountActivity: suspiciousAccountActivity,
            shippingDetailsUsage: shippingDetailsUsage?.request,
            paymentAccountDetails: paymentAccountDetails?.request,
            userLogin: userLogin?.request,
            priorThreeDSAuthentication: priorThreeDSAuthentication?.request,
            travelDetails: travelDetails?.request
        )
    }
}
