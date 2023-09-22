//
//  PSCardNumberInputViewTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore
import XCTest

final class PSCardNumberInputViewTests: XCTestCase {
    func test_init() {
        // When
        let sut = PSCardNumberInputView()

        // Then
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.separatorType, .whitespace)
    }

    func test_theme() {
        // Given
        let sut = PSCardNumberInputView()
        let theme = PSTheme()

        // When
        sut.theme = theme

        // Then
        XCTAssertEqual(sut.theme, theme)
    }

    func test_whitespaceSeparator() {
        // Given
        let separatorType: PSCardNumberInputSeparatorType = .whitespace

        // Then
        let sut = PSCardNumberInputView(separatorType: separatorType)

        // When
        XCTAssertEqual(sut.separatorType, .whitespace)
        XCTAssertEqual(sut.separatorType.separator, " ")
    }

    func test_noneSeparator() {
        // Given
        let separatorType: PSCardNumberInputSeparatorType = .none

        // Then
        let sut = PSCardNumberInputView(separatorType: separatorType)

        // When
        XCTAssertEqual(sut.separatorType, .none)
        XCTAssertEqual(sut.separatorType.separator, "")
    }

    func test_dashSeparator() {
        // Given
        let separatorType: PSCardNumberInputSeparatorType = .dash

        // Then
        let sut = PSCardNumberInputView(separatorType: separatorType)

        // When
        XCTAssertEqual(sut.separatorType, .dash)
        XCTAssertEqual(sut.separatorType.separator, "-")
    }

    func test_slashSeparator() {
        // Given
        let separatorType: PSCardNumberInputSeparatorType = .slash

        // Then
        let sut = PSCardNumberInputView(separatorType: separatorType)

        // When
        XCTAssertEqual(sut.separatorType, .slash)
        XCTAssertEqual(sut.separatorType.separator, "/")
    }

    func test_onEventSetter() {
        // Given
        let sut = PSCardNumberInputView()
        let onEvent: PSCardFieldInputEventBlock = { _ in }

        // When
        sut.onEvent = onEvent

        // Then
        XCTAssertNotNil(sut.onEvent)
    }

    func test_validCardNumber_events() {
        // Given
        let sut = PSCardNumberInputView()
        let validCardNumber = "4242424242424242"
        var events: [PSCardFieldInputEvent] = []
        sut.onEvent = { event in
            events.append(event)
        }

        // When
        sut.updateInput(with: validCardNumber)

        // Then
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.first, .fieldValueChange)
        XCTAssertEqual(events.last, .valid)
    }

    func test_invalidCardNumber_events() {
        // Given
        let sut = PSCardNumberInputView()
        let invalidCardNumber = "4242424242424243"
        var events: [PSCardFieldInputEvent] = []
        sut.onEvent = { event in
            events.append(event)
        }

        // When
        sut.updateInput(with: invalidCardNumber)

        // Then
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.first, .fieldValueChange)
        XCTAssertEqual(events.last, .invalid)
    }

    func test_emptyCardNumber_isEmpty() {
        // Given
        let sut = PSCardNumberInputView()
        let emptyCardNumber = ""

        // When
        sut.updateInput(with: emptyCardNumber)

        // Then
        XCTAssertTrue(sut.isEmpty())
    }

    func test_validCardNumber_isEmpty() {
        // Given
        let sut = PSCardNumberInputView()
        let validCardNumber = "4242424242424242"

        // When
        sut.updateInput(with: validCardNumber)

        // Then
        XCTAssertFalse(sut.isEmpty())
    }

    func test_validCardNumber_isValid() {
        // Given
        let sut = PSCardNumberInputView()
        let validCardNumber = "4242424242424242"

        // When
        sut.updateInput(with: validCardNumber)

        // Then
        XCTAssertTrue(sut.isValid())
    }

    func test_invalidCardNumber_isValid() {
        // Given
        let sut = PSCardNumberInputView()
        let invalidCardNumber = "4242424242424243"

        // When
        sut.updateInput(with: invalidCardNumber)

        // Then
        XCTAssertFalse(sut.isValid())
    }

    func test_reset() {
        // Given
        let sut = PSCardNumberInputView()
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

private extension PSCardNumberInputView {
    func updateInput(with text: String) {
        // Update the text field value
        cardNumberTextField.text = text
        // Trigger textDidChange event
        cardNumberTextField.textDidChange()
    }
}
