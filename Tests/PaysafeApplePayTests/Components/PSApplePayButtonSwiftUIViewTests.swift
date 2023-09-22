//
//  PSApplePayButtonSwiftUIViewTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeApplePay
import XCTest

final class PSApplePayButtonSwiftUIViewTests: XCTestCase {
    var sut: PSApplePayButtonSwiftUIView!

    override func setUp() {
        super.setUp()
        sut = PSApplePayButtonSwiftUIView(
            buttonType: .buy,
            buttonStyle: .automatic,
            action: nil
        )
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init() {
        XCTAssertNotNil(sut)
    }
}
