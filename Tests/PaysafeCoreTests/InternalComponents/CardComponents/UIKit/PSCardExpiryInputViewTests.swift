//
//  PSCardExpiryInputViewTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore
import XCTest

final class PSCardExpiryInputViewTests: XCTestCase {
    func test_init() {
        // When
        let sut = PSCardExpiryInputView()

        // Then
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.inputType, .datePicker)
    }

    func test_theme() {
        // Given
        let sut = PSCardExpiryInputView()
        let theme = PSTheme()

        // When
        sut.theme = theme

        // Then
        XCTAssertEqual(sut.theme, theme)

        sut.resetTheme()

        XCTAssertEqual(sut.theme, PaysafeSDK.shared.psTheme)
    }

    func test_textInput() {
        // Given
        let inputType: PSCardExpiryInputType = .text

        // When
        let sut = PSCardExpiryInputView(inputType: inputType)

        // Then
        XCTAssertEqual(sut.inputType, .text)
    }

    func test_datePickerInput() {
        // Given
        let inputType: PSCardExpiryInputType = .datePicker

        // When
        let sut = PSCardExpiryInputView(inputType: inputType)

        // Then
        XCTAssertEqual(sut.inputType, .datePicker)
    }

    func test_onEventSetter() {
        // Given
        let sut = PSCardExpiryInputView()
        let onEvent: PSCardFieldInputEventBlock = { _ in }

        // When
        sut.onEvent = onEvent

        // Then
        XCTAssertNotNil(sut.onEvent)
    }

    func test_validCardExpiry_events() {
        // Given
        let sut = PSCardExpiryInputView()
        let validCardExpiry = validExpiryDate()
        var events: [PSCardFieldInputEvent] = []
        sut.onEvent = { event in
            events.append(event)
        }

        // When
        sut.updateInput(with: validCardExpiry)

        // Then
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.first, .fieldValueChange)
        XCTAssertEqual(events.last, .valid)
    }

    func test_PSCardNumberInputView_invalidCardExpiry_events() {
        // Given
        let sut = PSCardExpiryInputView()
        let invalidCardExpiry = invalidExpiryDate()
        var events: [PSCardFieldInputEvent] = []
        sut.onEvent = { event in
            events.append(event)
        }

        // When
        sut.updateInput(with: invalidCardExpiry)

        // Then
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.first, .fieldValueChange)
        XCTAssertEqual(events.last, .invalid)
    }

    func test_emptyCardExpiry_isEmpty() {
        // Given
        let sut = PSCardExpiryInputView()
        let emptyCardExpiry = ""

        // When
        sut.updateInput(with: emptyCardExpiry)

        // Then
        XCTAssertTrue(sut.isEmpty())
    }

    func test_validCardExpiry_isEmpty() {
        // Given
        let sut = PSCardExpiryInputView()
        let validCardExpiry = validExpiryDate()

        // When
        sut.updateInput(with: validCardExpiry)

        // Then
        XCTAssertFalse(sut.isEmpty())
    }

    func test_validCardExpiry_isValid() {
        // Given
        let sut = PSCardExpiryInputView()
        let validCardExpiry = validExpiryDate()

        // When
        sut.updateInput(with: validCardExpiry)

        // Then
        XCTAssertTrue(sut.isValid())
    }

    func test_invalidCardNumber_isValid() {
        // Given
        let sut = PSCardExpiryInputView()
        let invalidCardExpiry = invalidExpiryDate()

        // When
        sut.updateInput(with: invalidCardExpiry)

        // Then
        XCTAssertFalse(sut.isValid())
    }

    func test_reset() {
        // Given
        let sut = PSCardExpiryInputView()
        let validCardExpiry = validExpiryDate()
        sut.updateInput(with: validCardExpiry)

        XCTAssertFalse(sut.isEmpty())
        XCTAssertTrue(sut.isValid())

        // When
        sut.reset()

        // Then
        XCTAssertTrue(sut.isEmpty())
        XCTAssertFalse(sut.isValid())
    }
}

private extension PSCardExpiryInputViewTests {
    func validExpiryDate() -> String {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        let validMonth = String(format: "%02d", currentMonth)
        let validYear = String(currentYear).suffix(2)
        return "\(validMonth) / \(validYear)"
    }

    func invalidExpiryDate() -> String {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        let validMonth = String(format: "%02d", currentMonth)
        let expiredYear = String(currentYear - 1).suffix(2)
        return "\(validMonth) / \(expiredYear)"
    }
}

private extension PSCardExpiryInputView {
    func updateInput(with text: String) {
        // Update the text field value
        cardExpiryTextField.text = text
        // Trigger textDidChange event
        cardExpiryTextField.textDidChange()
    }
}
