//
//  PSApplePayTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import PassKit
@testable import PaysafeApplePay
import XCTest

final class PSApplePayTests: XCTestCase {
    var sut: PSApplePay!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = PSApplePay(
            merchantIdentifier: "merchantIdentifier",
            countryCode: "US",
            supportedNetworks: [
                SupportedNetwork(
                    network: .amex,
                    capability: .both
                ),
                SupportedNetwork(
                    network: .visa,
                    capability: .credit
                ),
                SupportedNetwork(
                    network: .masterCard,
                    capability: .both
                ),
                SupportedNetwork(
                    network: .discover,
                    capability: .both
                )
            ]
        )
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_init() {
        XCTAssertNotNil(sut)
    }
    
    func test_paymentRequest() {
        // Given
        let merchantIdentifier = "merchantIdentifier"
        let countryCode = "US"
        let supportedNetworks: [SupportedNetwork] = [
            SupportedNetwork(
                network: .amex,
                capability: .both
            ),
            SupportedNetwork(
                network: .visa,
                capability: .credit
            ),
            SupportedNetwork(
                network: .masterCard,
                capability: .both
            ),
            SupportedNetwork(
                network: .discover,
                capability: .both
            )
        ]
        // Then
        XCTAssertEqual(sut.paymentRequest.merchantIdentifier, merchantIdentifier)
        XCTAssertEqual(Set(sut.paymentRequest.supportedNetworks), Set(supportedNetworks.map(\.network)))
        XCTAssertEqual(sut.paymentRequest.merchantCapabilities, [.threeDSecure, .debit, .credit])
        XCTAssertEqual(sut.paymentRequest.countryCode, countryCode)
    }
    
    func test_initiateApplePayFlow_requestBillingAddress_false() throws {
        // Given
        let currencyCode = "USD"
        let amount: Double = 10
        let psApplePay = PSApplePayItem(
            label: "Test item",
            requestBillingAddress: false
        )
        
        // When
        sut.initiateApplePayFlow(
            currencyCode: currencyCode,
            amount: amount,
            psApplePay: psApplePay
        )
        .sink { applePayResult in
            guard case let .success(initializeApplePayResponse) = applePayResult else { return }
            initializeApplePayResponse.completion?(.success, nil)
        }
        .store(in: &cancellables)
        
        // Then
        let authorizationController = try XCTUnwrap(sut.authorizationController)
        let paymentRequest = sut.paymentRequest
        authorizationController.delegate?.paymentAuthorizationController?(
            authorizationController,
            didAuthorizePayment: PKPayment(),
            handler: { result in
                XCTAssertEqual(result.status, .success)
                XCTAssertEqual(paymentRequest.currencyCode, currencyCode)
                XCTAssertEqual(
                    paymentRequest.paymentSummaryItems,
                    [
                        PKPaymentSummaryItem(
                            label: psApplePay.label,
                            amount: NSDecimalNumber(value: amount)
                        )
                    ]
                )
                XCTAssert(paymentRequest.requiredBillingContactFields.isEmpty)
            }
        )
    }
    
    func test_initiateApplePayFlow_requestBillingAddress_true() throws {
        // Given
        let currencyCode = "USD"
        let amount: Double = 10
        let psApplePay = PSApplePayItem(
            label: "Test item",
            requestBillingAddress: true
        )
        
        // When
        sut.initiateApplePayFlow(
            currencyCode: currencyCode,
            amount: amount,
            psApplePay: psApplePay
        )
        .sink { applePayResult in
            guard case let .success(initializeApplePayResponse) = applePayResult else { return }
            initializeApplePayResponse.completion?(.success, nil)
        }
        .store(in: &cancellables)
        
        // Then
        let authorizationController = try XCTUnwrap(sut.authorizationController)
        let paymentRequest = sut.paymentRequest
        authorizationController.delegate?.paymentAuthorizationController?(
            authorizationController,
            didAuthorizePayment: PKPayment(),
            handler: { result in
                XCTAssertEqual(result.status, .success)
                XCTAssertEqual(paymentRequest.currencyCode, currencyCode)
                XCTAssertEqual(
                    paymentRequest.paymentSummaryItems,
                    [
                        PKPaymentSummaryItem(
                            label: psApplePay.label,
                            amount: NSDecimalNumber(value: amount)
                        )
                    ]
                )
                XCTAssertEqual(paymentRequest.requiredBillingContactFields,
                               [
                                .name,
                                .emailAddress,
                                .postalAddress,
                                .phoneNumber
                               ])
            }
        )
    }
    
    func test_constructName_fullName() {
        // Given
        let firstName = "Test"
        let lastName = "Last"
        
        // When
        let fullName = sut.constructName(using: firstName, and: lastName)
        
        // Then
        XCTAssertNotNil(fullName)
        XCTAssertEqual(fullName, "\(firstName) \(lastName)")
    }
    
    func test_constructName_just_firstName() {
        // Given
        let firstName = "Test"
        let lastName: String? = nil
        
        // When
        let fullName = sut.constructName(using: firstName, and: lastName)
        
        // Then
        XCTAssertNotNil(fullName)
        XCTAssertEqual(fullName, "\(firstName)")
    }
    
    func test_constructName_just_lastName() {
        // Given
        let firstName: String? = nil
        let lastName = "Test"
        
        // When
        let fullName = sut.constructName(using: firstName, and: lastName)
        
        // Then
        XCTAssertNotNil(fullName)
        XCTAssertEqual(fullName, "\(lastName)")
    }
    
    func testMapPKContactToBillingContact_WithNilPKContact_ShouldReturnNil() {
        let result = sut.mapPKContactToBillingContact(nil)
        XCTAssertNil(result)
    }
    
    func testMapPKContactToBillingContact_WithValidPKContact_ShouldMapCorrectly() {
        // Create a mock CNPostalAddress
        let postalAddress = CNMutablePostalAddress()
        postalAddress.street = "123 Main St\nApt 4B"
        postalAddress.city = "Anytown"
        postalAddress.state = "CA"
        postalAddress.postalCode = "12345"
        postalAddress.country = "USA"
        postalAddress.isoCountryCode = "US"
        
        // Create a mock PersonNameComponents
        var nameComponents = PersonNameComponents()
        nameComponents.givenName = "John"
        nameComponents.familyName = "Doe"
        
        // Create a mock PKContact
        let pkContact = PKContact()
        pkContact.name = nameComponents
        pkContact.postalAddress = postalAddress
        pkContact.emailAddress = "john.doe@example.com"
        pkContact.phoneNumber = CNPhoneNumber(stringValue: "1234567890")
        
        // Expected BillingContact
        let expectedBillingContact = BillingContact(
            addressLines: ["123 Main St", "Apt 4B"],
            countryCode: "US",
            email: "john.doe@example.com",
            locality: "Anytown",
            name: "John Doe",
            phone: "1234567890",
            country: "USA",
            postalCode: "12345",
            administrativeArea: "CA"
        )
        
        let result = sut.mapPKContactToBillingContact(pkContact)
        
        XCTAssertEqual(result?.addressLines, expectedBillingContact.addressLines)
        XCTAssertEqual(result?.countryCode, expectedBillingContact.countryCode)
        XCTAssertEqual(result?.email, expectedBillingContact.email)
        XCTAssertEqual(result?.locality, expectedBillingContact.locality)
        XCTAssertEqual(result?.name, expectedBillingContact.name)
        XCTAssertEqual(result?.phone, expectedBillingContact.phone)
        XCTAssertEqual(result?.country, expectedBillingContact.country)
        XCTAssertEqual(result?.postalCode, expectedBillingContact.postalCode)
        XCTAssertEqual(result?.administrativeArea, expectedBillingContact.administrativeArea)
    }
}
