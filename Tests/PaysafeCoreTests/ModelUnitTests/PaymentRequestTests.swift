//
//  PaymentRequestTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore
import XCTest

class PaymentRequestTests: XCTestCase {
    func test_paymentRequest_Encoding() throws {
        // Given
        let merchantRefNum = "testMerchantRef"
        let transactionType = TransactionTypeRequest.payment
        let card = CardRequest(cvv: "111", holderName: "John Doe")
        let accountId = "testAccountId"
        let paymentType = PaymentType.card
        let amount = 1000
        let currencyCode = "USD"
        let returnLinks = [
            ReturnLinkRequest(
                rel: .onCompleted,
                href: "",
                method: ""
            )
        ]
        let profile = ProfileRequest(
            firstName: "John",
            lastName: "Doe",
            locale: LocaleRequest(rawValue: ""),
            merchantCustomerId: "sampleCustomerId",
            dateOfBirth: DateOfBirthRequest(day: 10, month: 02, year: 1992),
            email: "john.doe@example.com",
            phone: "1234567890",
            mobile: "0987654321",
            gender: GenderRequest.male,
            nationality: "SampleNationality",
            identityDocuments: [
                IdentityDocumentRequest(documentNumber: "123456789")
            ]
        )

        let paymentRequest = PaymentRequest(
            merchantRefNum: merchantRefNum,
            transactionType: transactionType,
            card: card,
            accountId: accountId,
            paymentType: paymentType,
            amount: amount,
            currencyCode: currencyCode,
            returnLinks: returnLinks,
            profile: profile,
            threeDs: nil,
            billingDetails: nil,
            merchantDescriptor: nil,
            shippingDetails: nil,
            singleUseCustomerToken: nil,
            paymentHandleTokenFrom: nil,
            applePay: nil,
            paypal: nil
        )

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(paymentRequest)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

        // Then
        XCTAssertEqual(dictionary?["merchantRefNum"] as? String, merchantRefNum)
        XCTAssertEqual(dictionary?["transactionType"] as? String, transactionType.rawValue)
        XCTAssertEqual(dictionary?["accountId"] as? String, accountId)
        XCTAssertEqual(dictionary?["paymentType"] as? String, paymentType.rawValue)
        XCTAssertEqual(dictionary?["amount"] as? Int, amount)
        XCTAssertEqual(dictionary?["currencyCode"] as? String, currencyCode)

        if let profileDict = dictionary?["profile"] as? [String: Any] {
            XCTAssertEqual(profileDict["firstName"] as? String, "John")
            if let identityDocumentsArray = profileDict["identityDocuments"] as? [[String: Any]] {
                XCTAssertEqual(identityDocumentsArray.count, 1, "There should be one identity document")

                let identityDocumentDict = identityDocumentsArray.first!
                XCTAssertEqual(identityDocumentDict["documentNumber"] as? String, "123456789", "Document number should match")
                XCTAssertEqual(identityDocumentDict["type"] as? String, "SOCIAL_SECURITY", "Type should be SOCIAL_SECURITY")
            }
        }
    }
}
