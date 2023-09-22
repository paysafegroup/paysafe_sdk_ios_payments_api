//
//  CurrencyConverterTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCommon
import XCTest

final class CurrencyConverterTests: XCTestCase {
    var sut: CurrencyConverter!

    override func setUp() {
        super.setUp()
        let conversionRules = CurrencyConverter.defaultCurrenciesMap()
        sut = CurrencyConverter(conversionRules: conversionRules)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_withDefaultCurrenciesMap() {
        XCTAssertNotNil(sut, "The CurrencyConverter should be initialized.")
    }

    func test_convert_withSupportedCurrency_returnsCorrectValue() {
        // Given
        let amount = 1000 // Example amount in minor units
        let currency = "JPY" // Example currency with 0 decimal places

        // When
        let result = sut.convert(amount: amount, forCurrency: currency)

        // Then
        XCTAssertEqual(result, 1000.0, "Conversion for JPY should correctly convert without altering the amount.")
    }

    func test_convert_withUnsupportedCurrency_returnsInitialValueDividedBy100() {
        // Given
        let amount = 1000
        let unsupportedCurrency = "XXX"

        // When
        let result = sut.convert(amount: amount, forCurrency: unsupportedCurrency)

        // Then
        XCTAssertEqual(result, 10.0, "Conversion for JPY should correctly convert without altering the amount.")
    }

    func test_convert_withHighPrecisionCurrency_returnsCorrectValue() {
        // Given
        let amount = 12_345_699 // Example amount in minor units
        let currency = "BHD" // Example currency with 3 decimal places

        // When
        let result = sut.convert(amount: amount, forCurrency: currency)

        // Then
        XCTAssertEqual(result, 12345.699, "Conversion for BHD should correctly apply the 3 decimal place conversion.")
    }

    func test_convert_withZeroPrecisionCurrency_returnsCorrectValue() {
        // Given
        let amount = 500
        let currency = "KRW" // Example currency with 0 decimal places

        // When
        let result = sut.convert(amount: amount, forCurrency: currency)

        // Then
        XCTAssertEqual(result, 500.0, "Conversion for KRW should correctly convert without altering the amount.")
    }
}
