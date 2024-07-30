//
//  PSApplePayButtonSwiftUIViewTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeApplePay
import XCTest

final class PSApplePayButtonSwiftUIViewTests: XCTestCase {
    
    func test_init() {
        // Given
        let sut = PSApplePayButtonSwiftUIView(
            buttonType: .buy,
            buttonStyle: .automatic,
            action: nil
        )
        // Then
        XCTAssertNotNil(sut)
    }
}
