//
//  ThreeDSRequestTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore
import XCTest

class ThreeDSRequestTests: XCTestCase {
    func test_threeDSRequest_Encoding() throws {
        // Given
        let merchantUrl = "http://paysafe.com"
        let messageCategory = MessageCategoryRequest.payment
        let authenticationPurpose = AuthenticationPurposeRequest.paymentTransaction

        let request = ThreeDSRequest(
            merchantRefNum: nil,
            merchantUrl: merchantUrl,
            messageCategory: messageCategory,
            transactionIntent: nil,
            billingCycle: nil,
            authenticationPurpose: authenticationPurpose,
            requestorChallengePreference: nil,
            userLogin: nil,
            orderItemDetails: nil,
            purchasedGiftCardDetails: nil,
            userAccountDetails: nil,
            priorThreeDSAuthentication: nil,
            shippingDetailsUsage: nil,
            suspiciousAccountActivity: nil,
            totalPurchasesSixMonthCount: nil,
            transactionCountForPreviousDay: nil,
            transactionCountForPreviousYear: nil,
            travelDetails: nil,
            maxAuthorizationsForInstalmentPayment: nil,
            electronicDelivery: nil,
            initialPurchaseTime: nil
        )

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(request)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

        // Then
        XCTAssertNotNil(json, "Encoded object should be convertible to JSON dictionary.")
        XCTAssertEqual(json?["merchantUrl"] as? String, merchantUrl, "merchantUrl should be correctly encoded")
        XCTAssertEqual(json?["messageCategory"] as? String, messageCategory.rawValue, "messageCategory should be correctly encoded")
        XCTAssertEqual(json?["authenticationPurpose"] as? String, authenticationPurpose.rawValue, "authenticationPurpose should be correctly encoded")
    }
}
