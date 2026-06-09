//
//  PSCardNumberInputSwiftUIViewTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCardPayments
import SwiftUI
import UIKit
import XCTest

final class PSCardNumberInputSwiftUIViewTests: XCTestCase {
    var sut: PSCardNumberInputSwiftUIView!

    override func setUp() {
        super.setUp()
        sut = PSCardNumberInputSwiftUIView(separatorType: .whitespace, animateTopPlaceholderLabel: true, hint: "hint")
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init() {
        XCTAssertNotNil(sut)
    }

    func test_theme() {
        // Given
        let theme = PSTheme()

        // When
        sut.theme = theme

        // Then
        XCTAssertEqual(sut.theme, theme)

        sut.resetTheme()
        // Then
        XCTAssertEqual(sut.theme, PaysafeSDK.shared.psTheme)
    }

    func test_onEventSetter() {
        // Given
        let onEvent: PSCardFieldInputEventBlock = { _ in }

        // When
        sut.onEvent = onEvent

        // Then
        XCTAssertNotNil(sut.onEvent)
    }

    func test_placeholder() {
        // Given
        let hint = "Card number"

        // Then
        XCTAssertEqual(sut.getPlaceholder(), hint)
    }

    func test_isEmpty() {
        // Given
        let validCardNumber = "4242424242424242"

        // When
        sut.updateInput(with: validCardNumber)

        // Then
        XCTAssertFalse(sut.isEmpty())
    }

    func test_isValid() {
        // Given
        let validCardNumber = "4242424242424242"

        // When
        sut.updateInput(with: validCardNumber)

        // Then
        XCTAssertTrue(sut.isValid())
    }

    func test_reset() {
        // Given
        let validCardNumber = "4242424242424242"
        sut.updateInput(with: validCardNumber)

        XCTAssertFalse(sut.isEmpty())
        XCTAssertTrue(sut.isValid())

        // When
        sut.reset()

        // Then
        XCTAssertTrue(sut.isEmpty())
        XCTAssertFalse(sut.isValid())
    }

    func test_label_forwardsToUnderlyingTextField() {
        // Given
        let localized = "Numéro de carte"

        // When
        let sut = PSCardNumberInputSwiftUIView(label: localized)

        // Then
        XCTAssertEqual(sut.cardNumberView.cardNumberTextField.placeholders[.normal], localized)
        XCTAssertEqual(sut.cardNumberView.cardNumberTextField.placeholders[.error], localized)
    }

    func test_hasText_reflectsUnderlyingField() {
        XCTAssertFalse(sut.hasText())
        sut.updateInput(with: "4")
        XCTAssertTrue(sut.hasText())
        sut.reset()
        XCTAssertFalse(sut.hasText())
    }

    func test_hostingController_invokesRepresentableLifecycle() {
        let exp = expectation(description: "hosting")
        DispatchQueue.main.async {
            let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 56))
            window.rootViewController = UIHostingController(rootView: PSCardNumberInputSwiftUIView())
            window.isHidden = false
            window.layoutIfNeeded()
            XCTAssertNotNil(window.rootViewController?.view)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
}

private extension PSCardNumberInputSwiftUIView {
    func updateInput(with text: String) {
        // Update the text field value
        cardNumberView.cardNumberTextField.text = text
        // Trigger textDidChange event
        cardNumberView.cardNumberTextField.textDidChange()
    }
}
