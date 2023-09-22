//
//  PSApplePayButtonViewTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import PassKit
@testable import PaysafeApplePay
import XCTest

final class PSApplePayButtonViewTests: XCTestCase {
    func test_init_buyType() {
        // Given
        let sut = PSApplePayButtonView(
            buttonType: .buy,
            buttonStyle: .automatic,
            action: nil
        )

        // Then
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.buttonType, .buy)
        XCTAssertEqual(sut.buttonStyle, .automatic)
    }

    func test_init_donateType() {
        // Given
        let sut = PSApplePayButtonView(
            buttonType: .donate,
            buttonStyle: .automatic,
            action: nil
        )

        // Then
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.buttonType, .donate)
        XCTAssertEqual(sut.buttonStyle, .automatic)
    }

    func test_action() {
        // Given
        var actionCalled = false
        let sut = PSApplePayButtonView(
            buttonType: .donate,
            buttonStyle: .automatic
        ) {
            actionCalled = true
        }

        // When
        sut.handleTap()

        // Then
        XCTAssertTrue(actionCalled)
    }

    func test_associated_PKPaymentButtonType() {
        // Given
        let buttonTypes: [(PSApplePayButtonView.ButtonType, PKPaymentButtonType)] = [
            (.buy, .buy),
            (.donate, .donate)
        ]

        // When
        buttonTypes.forEach { buttonType, expectedButtonType in
            // Then
            XCTAssertEqual(buttonType.toPKPaymentButtonType, expectedButtonType)
        }
    }

    func test_associated_PKPaymentButtonStyle() {
        // Given
        var buttonStyles: [(PSApplePayButtonView.ButtonStyle, PKPaymentButtonStyle)] = []
        buttonStyles.append((.white, .white))
        buttonStyles.append((.whiteOutline, .whiteOutline))
        buttonStyles.append((.black, .black))
        buttonStyles.append((.automatic, .automatic))

        // When
        buttonStyles.forEach { buttonStyle, expectedButtonStyle in
            // Then
            XCTAssertEqual(buttonStyle.toPKPaymentButtonStyle, expectedButtonStyle)
        }
    }
}
