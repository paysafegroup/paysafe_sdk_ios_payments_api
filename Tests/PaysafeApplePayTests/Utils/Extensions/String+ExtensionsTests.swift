//
//  String+ExtensionsTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeApplePay
import PassKit
import XCTest

class StringExtensionTests: XCTestCase {
    func test_pkPaymentMethodType_unknown() {
        // Given
        let emptyStrmethodType = PKPaymentMethodType.unknown

        // Then
        XCTAssertEqual(emptyStrmethodType.toString(), "unknown")
    }

    func test_pkPaymentMethodType_debit() {
        // Given
        let emptyStrmethodType = PKPaymentMethodType.debit

        // Then
        XCTAssertEqual(emptyStrmethodType.toString(), "debit")
    }
    
    func test_pkPaymentMethodType_credit() {
        // Given
        let emptyStrmethodType = PKPaymentMethodType.credit

        // Then
        XCTAssertEqual(emptyStrmethodType.toString(), "credit")
    }
    
    func test_pkPaymentMethodType_prepaid() {
        // Given
        let emptyStrmethodType = PKPaymentMethodType.prepaid

        // Then
        XCTAssertEqual(emptyStrmethodType.toString(), "prepaid")
    }
    
    func test_pkPaymentMethodType_store() {
        // Given
        let emptyStrmethodType = PKPaymentMethodType.store

        // Then
        XCTAssertEqual(emptyStrmethodType.toString(), "store")
    }
    
}
