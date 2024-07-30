//
//  PSCardholderNameInputSwiftUIViewTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore
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
        XCTAssertEqual(sut.theme, PaysafeSDK.shared.psTheme)
        
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
}

private extension PSCardholderNameInputSwiftUIView {
    func updateInput(with text: String) {
        // Update the text field value
        cardholderNameView.cardholderNameTextField.text = text
        // Trigger textDidChange event
        cardholderNameView.cardholderNameTextField.textDidChange()
    }
}
