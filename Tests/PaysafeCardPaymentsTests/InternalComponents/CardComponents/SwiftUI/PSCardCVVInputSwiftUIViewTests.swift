//
//  PSCardCVVInputSwiftUIViewTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCardPayments
import SwiftUI
import UIKit
import XCTest

final class PSCardCVVInputSwiftUIViewTests: XCTestCase {
    var sut: PSCardCVVInputSwiftUIView!

    override func setUp() {
        super.setUp()
        sut = PSCardCVVInputSwiftUIView()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init() {
        sut = PSCardCVVInputSwiftUIView(isMasked: true, cardBrand: .mastercard)
        
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.getPlaceholder())
        XCTAssertTrue(sut.isEmpty())
        
        sut.reset()
        XCTAssertTrue(sut.isEmpty())
    }

    func test_theme() {
        // Given
        let theme = PSTheme()

        // When
        sut.theme = theme

        // Then
        XCTAssertEqual(sut.theme, theme)
        
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
        let validCardCVV = "123"

        // When
        sut.updateInput(with: validCardCVV)

        // Then
        XCTAssertFalse(sut.isEmpty())
    }

    func test_isValid() {
        // Given
        let validCardCVV = "123"

        // When
        sut.updateInput(with: validCardCVV)

        // Then
        XCTAssertTrue(sut.isValid())
    }

    func test_reset() {
        // Given
        let validCardCVV = "123"
        sut.updateInput(with: validCardCVV)

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
        let localized = "Cryptogramme visuel"

        // When
        let sut = PSCardCVVInputSwiftUIView(label: localized)

        // Then
        XCTAssertEqual(sut.cardCVVView.cardCVVTextField.placeholders[.normal], localized)
        XCTAssertEqual(sut.cardCVVView.cardCVVTextField.placeholders[.error], localized)
    }

    func test_hasText_reflectsUnderlyingField() {
        XCTAssertFalse(sut.hasText())
        sut.updateInput(with: "1")
        XCTAssertTrue(sut.hasText())
        sut.reset()
        XCTAssertFalse(sut.hasText())
    }

    func test_hostingController_invokesRepresentableLifecycle() {
        let exp = expectation(description: "hosting")
        DispatchQueue.main.async {
            let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 56))
            window.rootViewController = UIHostingController(rootView: PSCardCVVInputSwiftUIView())
            window.isHidden = false
            window.layoutIfNeeded()
            XCTAssertNotNil(window.rootViewController?.view)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
}

private extension PSCardCVVInputSwiftUIView {
    func updateInput(with text: String) {
        // Update the text field value
        cardCVVView.cardCVVTextField.text = text
        // Trigger textDidChange event
        cardCVVView.cardCVVTextField.textDidChange()
    }
}
