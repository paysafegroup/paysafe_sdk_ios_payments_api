//
//  PSCardNumberInputSwiftUIViewTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore
import XCTest

final class PSCardNumberInputSwiftUIViewTests: XCTestCase {
    var sut: PSCardNumberInputSwiftUIView!

    override func setUp() {
        super.setUp()
        sut = PSCardNumberInputSwiftUIView()
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
}

private extension PSCardNumberInputSwiftUIView {
    func updateInput(with text: String) {
        // Update the text field value
        cardNumberView.cardNumberTextField.text = text
        // Trigger textDidChange event
        cardNumberView.cardNumberTextField.textDidChange()
    }
}
