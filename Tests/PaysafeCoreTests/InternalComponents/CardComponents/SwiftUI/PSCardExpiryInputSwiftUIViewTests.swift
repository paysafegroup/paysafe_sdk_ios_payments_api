//
//  PSCardExpiryInputSwiftUIViewTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCore
import XCTest

final class PSCardExpiryInputSwiftUIViewTests: XCTestCase {
    var sut: PSCardExpiryInputSwiftUIView!

    override func setUp() {
        super.setUp()
        sut = PSCardExpiryInputSwiftUIView()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init() {
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.getPlaceholder())
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
        let validCardExpiry = validExpiryDate()

        // When
        sut.updateInput(with: validCardExpiry)

        // Then
        XCTAssertFalse(sut.isEmpty())
    }

    func test_isValid() {
        // Given
        let validCardExpiry = validExpiryDate()

        // When
        sut.updateInput(with: validCardExpiry)

        // Then
        XCTAssertTrue(sut.isValid())
    }

    func test_reset() {
        // Given
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

private extension PSCardExpiryInputSwiftUIViewTests {
    func validExpiryDate() -> String {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        let validMonth = String(format: "%02d", currentMonth)
        let validYear = String(currentYear).suffix(2)
        return "\(validMonth) / \(validYear)"
    }
}

private extension PSCardExpiryInputSwiftUIView {
    func updateInput(with text: String) {
        // Update the text field value
        cardExpiryView.cardExpiryTextField.text = text
        // Trigger textDidChange event
        cardExpiryView.cardExpiryTextField.textDidChange()
    }
}
