//
//  ThreeDSRequestTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCommon
import XCTest

class ThreeDSRequestTests: XCTestCase {
    func test_threeDSRequest_Encoding() throws {
        // Given
        let merchantUrl = "http://paysafe.com"
        let messageCategory = MessageCategoryRequest.payment
        let authenticationPurpose = AuthenticationPurposeRequest.paymentTransaction
        let billingCycleRequest = BillingCycleRequest(
            endDate: "12-03-2025",
            frequency: 2
        )

        var request = ThreeDSRequest(
            merchantRefNum: nil,
            merchantUrl: merchantUrl,
            messageCategory: messageCategory,
            transactionIntent: nil,
            billingCycle: billingCycleRequest,
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
        request.deviceChannel = .sdk

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(request)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

        // Then
        XCTAssertEqual(request.deviceChannel, .sdk)
        XCTAssertNotNil(json, "Encoded object should be convertible to JSON dictionary.")
        XCTAssertEqual(json?["merchantUrl"] as? String, merchantUrl, "merchantUrl should be correctly encoded")
        XCTAssertEqual(json?["messageCategory"] as? String, messageCategory.rawValue, "messageCategory should be correctly encoded")
        XCTAssertEqual(json?["authenticationPurpose"] as? String, authenticationPurpose.rawValue, "authenticationPurpose should be correctly encoded")

        XCTAssertEqual(request.billingCycle?.endDate, billingCycleRequest.endDate)
        XCTAssertEqual(request.billingCycle?.frequency, billingCycleRequest.frequency)
        XCTAssertNotNil(request.billingCycle)

        if let billingCycleJSON = json?["billingCycle"] as? [String: Any] {
            XCTAssertEqual(billingCycleJSON["endDate"] as? String, billingCycleRequest.endDate, "endDate should be correctly encoded")
            XCTAssertEqual(billingCycleJSON["frequency"] as? Int, billingCycleRequest.frequency, "frequency should be correctly encoded")
        } else {
            XCTFail("billingCycle was not found or is not a dictionary")
        }
    }
}
