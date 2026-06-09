//
//  File.swift
//  
//
//  Created by Eduardo Oliveros on 7/25/24.
//

import XCTest
import UIKit

@testable import PaysafeCardPayments

final class PSCardExpiryInputTextFieldTests: XCTestCase {
    func test_textFieldShouldChangeCharactersInRange() {
        // Given
        let sut = makeSUT()
        let newTextField = UITextField()
        newTextField.text = "Textfield Test"
        
        // When
        let shouldChange = sut.textField(newTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 2), replacementString: "Te")

        // Then
        XCTAssertFalse(shouldChange)
    }

    func test_textFieldShouldChange_validInput_onSelf_sameField() {
        let sut = makeSUT(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        sut.inputType = .text
        sut.text = ""
        let ok = sut.textField(sut, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "1")
        XCTAssertTrue(ok)
    }

    func test_validateCharacters_datePicker_returnsFalse() {
        let sut = makeSUT()
        sut.inputType = .datePicker
        XCTAssertFalse(sut.validate(characters: "0"))
    }

    func test_validateCharacters_textInput_delegatesToCardUtils() {
        let sut = makeSUT()
        sut.inputType = .text
        XCTAssertTrue(sut.validate(characters: "1"))
        XCTAssertFalse(sut.validate(characters: "a"))
    }

    func test_canPerformAction_rejectsNonPasteActions() {
        let sut = makeSUT()
        XCTAssertFalse(sut.canPerformAction(NSSelectorFromString("copy:"), withSender: nil))
        XCTAssertFalse(sut.canPerformAction(NSSelectorFromString("cut:"), withSender: nil))
    }

    func test_datePicker_caretAndSelection_suppressed() {
        let sut = makeSUT(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        sut.inputType = .datePicker
        let pos = sut.beginningOfDocument
        XCTAssertEqual(sut.caretRect(for: pos), .zero)
        if let start = sut.position(from: pos, offset: 0),
           let end = sut.position(from: pos, offset: 0),
           let range = sut.textRange(from: start, to: end) {
            XCTAssertTrue(sut.selectionRects(for: range).isEmpty)
        }
    }

    func test_datePicker_beginEditing_forwardsToPicker() {
        let sut = makeSUT(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        sut.inputType = .datePicker
        sut.textFieldDidBeginEditing(sut)
    }

    func test_customLabel_updatesPlaceholders() {
        let sut = makeSUT()
        sut.customLabel = "Localized expiry"
        XCTAssertEqual(sut.placeholders[.normal], "Localized expiry")
        XCTAssertEqual(sut.placeholders[.error], "Localized expiry")
    }

    func test_selectedPlaceholder_updatesSelectedStatePlaceholder() {
        let sut = makeSUT()
        sut.selectedPlaceholder = "MM / YY"
        XCTAssertEqual(sut.placeholders[.selected], "MM / YY")
    }
    
    func test_pickerViewSelectedDate() {
        // Given
        let month = 10
        let year = 24
        
        let sut = makeSUT()

        // When
        sut.pickerViewSelectedDate(month: month, year: year)

        // Then
        XCTAssertEqual(sut.text, String(format: "%02d / %02d", month, year))
    }

    private func makeSUT(frame: CGRect = .zero) -> PSCardExpiryInputTextField {
        .init(frame: frame)
    }
}
