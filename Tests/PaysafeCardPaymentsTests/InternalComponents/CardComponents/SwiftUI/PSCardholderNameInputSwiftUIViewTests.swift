//
//  PSCardholderNameInputSwiftUIViewTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCardPayments
import SwiftUI
import UIKit
import XCTest

final class PSCardholderNameInputSwiftUIViewTests: XCTestCase {
    var sut: PSCardholderNameInputSwiftUIView!

    override func setUp() {
        super.setUp()
        sut = PSCardholderNameInputSwiftUIView()
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
        XCTAssertEqual(sut.getPlaceholder(), "Cardholder Name")

        sut.resetTheme()

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

    func test_isEmpty() {
        // Given
        let validCardholderName = "John Doe"

        // When
        sut.updateInput(with: validCardholderName)

        // Then
        XCTAssertFalse(sut.isEmpty())
    }

    func test_isValid() {
        // Given
        let validCardholderName = "John Doe"

        // When
        sut.updateInput(with: validCardholderName)

        // Then
        XCTAssertTrue(sut.isValid())
    }

    func test_reset() {
        // Given
        let validCardholderName = "John Doe"
        sut.updateInput(with: validCardholderName)

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
        let localized = "Nom du titulaire"

        // When
        let sut = PSCardholderNameInputSwiftUIView(label: localized)

        // Then
        XCTAssertEqual(sut.cardholderNameView.cardholderNameTextField.placeholders[.normal], localized)
        XCTAssertEqual(sut.cardholderNameView.cardholderNameTextField.placeholders[.error], localized)
    }

    func test_hasText_reflectsUnderlyingField() {
        XCTAssertFalse(sut.hasText())
        sut.updateInput(with: "J")
        XCTAssertTrue(sut.hasText())
        sut.reset()
        XCTAssertFalse(sut.hasText())
    }

    func test_hostingController_invokesRepresentableLifecycle() {
        let exp = expectation(description: "hosting")
        DispatchQueue.main.async {
            let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 56))
            window.rootViewController = UIHostingController(rootView: PSCardholderNameInputSwiftUIView())
            window.isHidden = false
            window.layoutIfNeeded()
            XCTAssertNotNil(window.rootViewController?.view)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
}

private extension PSCardholderNameInputSwiftUIView {
    func updateInput(with text: String) {
        // Update the text field value
        cardholderNameView.cardholderNameTextField.text = text
        // Trigger textDidChange event
        cardholderNameView.cardholderNameTextField.textDidChange()
    }
}
