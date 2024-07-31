//
//  PSCardCVVInputViewTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore
import XCTest

final class PSCardCVVInputViewTests: XCTestCase {
    var sut: PSCardCVVInputView!

    override func setUp() {
        super.setUp()
        sut = PSCardCVVInputView()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init() {
        XCTAssertNotNil(sut)
        XCTAssertFalse(sut.isMasked)
        XCTAssertEqual(sut.cardBrand, .unknown)
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

    func test_validCardExpiry_events() {
        // Given
        let validCardCVV = "123"
        var events: [PSCardFieldInputEvent] = []
        sut.onEvent = { event in
            events.append(event)
        }

        // When
        sut.updateInput(with: validCardCVV)
        sut.isMasked = false
        sut.cardBrand = .mastercard

        // Then
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.first, .fieldValueChange)
        XCTAssertEqual(events.last, .valid)
    }

    func test_PSCardNumberInputView_invalidCardExpiry_events() {
        // Given
        let invalidCardCVV = "12"
        var events: [PSCardFieldInputEvent] = []
        sut.onEvent = { event in
            events.append(event)
        }

        // When
        sut.didUpdateCardCVVInputFocusedState(isFocused: false)
        sut.didUpdateCardCVVInputWithInvalidCharacter()
        sut.updateInput(with: invalidCardCVV)

        // Then
        XCTAssertEqual(events.count, 3)
        XCTAssertEqual(events.first, .invalidCharacter)
        XCTAssertEqual(events[1], .fieldValueChange)
        XCTAssertEqual(events.last, .invalid)
    }

    func test_emptyCardCVV_isEmpty() {
        // Given
        let emptyCardCVV = ""

        // When
        sut.updateInput(with: emptyCardCVV)

        // Then
        XCTAssertTrue(sut.isEmpty())
    }

    func test_validCardCVV_isEmpty() {
        // Given
        let validCardCVV = "123"

        // When
        sut.updateInput(with: validCardCVV)

        // Then
        XCTAssertFalse(sut.isEmpty())
    }

    func test_validCardCVV_isValid() {
        // Given
        let validCardCVV = "123"

        // When
        sut.updateInput(with: validCardCVV)

        // Then
        XCTAssertTrue(sut.isValid())
    }

    func test_invalidCardCVV_isValid() {
        // Given
        let invalidCardCVV = "12"

        // When
        sut.updateInput(with: invalidCardCVV)

        // Then
        XCTAssertFalse(sut.isValid())
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

    func testInitWithCoder() {
        // Given
        let object = PSCardCVVInputView()
        let data = try! NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
        let coder = try! NSKeyedUnarchiver(forReadingFrom: data)

        // When
        let sut = PSCardCVVInputView(coder: coder)

        // Then
        XCTAssertNotNil(sut)
    }
}

private extension PSCardCVVInputView {
    func updateInput(with text: String) {
        // Update the text field value
        cardCVVTextField.text = text
        // Trigger textDidChange event
        cardCVVTextField.textDidChange()
    }
}
