//
//  PSCardholderNameInputViewTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCardPayments
import PaysafeCommon
import XCTest

final class PSCardholderNameInputViewTests: XCTestCase {
    var sut: PSCardholderNameInputView!

    override func setUp() {
        super.setUp()
        sut = PSCardholderNameInputView()
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
        let theme = PSTheme(backgroundColor: .darkGray)

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

    func test_validCardholderName_events() {
        // Given
        let validCardholderName = "John Doe"
        var events: [PSCardFieldInputEvent] = []
        sut.onEvent = { event in
            events.append(event)
        }

        // When
        sut.updateInput(with: validCardholderName)

        // Then
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.first, .fieldValueChange)
        XCTAssertEqual(events.last, .valid)
    }

    func test_invalidCardholderName_events() {
        // Given
        let invalidCardholderName = "1234"
        var events: [PSCardFieldInputEvent] = []
        sut.onEvent = { event in
            events.append(event)
        }

        // When
        sut.updateInput(with: invalidCardholderName)

        // Then
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.first, .fieldValueChange)
        XCTAssertEqual(events.last, .invalid)
    }

    func test_emptyCardholderName_isEmpty() {
        // Given
        let emptyCardholderName = ""

        // When
        sut.updateInput(with: emptyCardholderName)

        // Then
        XCTAssertTrue(sut.isEmpty())
    }

    func test_validCardholderName_isEmpty() {
        // Given
        let validCardholderName = "John Doe"

        // When
        sut.updateInput(with: validCardholderName)

        // Then
        XCTAssertFalse(sut.isEmpty())
    }

    func test_validCardholderName_isValid() {
        // Given
        let validCardholderName = "John Doe"

        // When
        sut.updateInput(with: validCardholderName)

        // Then
        XCTAssertTrue(sut.isValid())
    }

    func test_invalidCardholderName_isValid() {
        // Given
        let invalidCardholderName = "1234"

        // When
        sut.updateInput(with: invalidCardholderName)

        // Then
        XCTAssertFalse(sut.isValid())
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

private extension PSCardholderNameInputView {
    func updateInput(with text: String) {
        // Update the text field value
        cardholderNameTextField.text = text
        // Trigger textDidChange event
        cardholderNameTextField.textDidChange()
    }
}
