//
//  PSCardCVVInputTextFieldTests.swift
//
//
//  Created by Eduardo Oliveros on 7/25/24.
//

import UIKit
import XCTest
@testable import PaysafeCardPayments

final class PSCardCVVInputTextFieldTests: XCTestCase {
    func test_textFieldShouldChangeCharactersInRange_ValidFormat() {
        // Given
        let sut = makeSUT()
        let newTextField = UITextField()
        newTextField.text = "333"

        // When
        let shouldChange = sut.textField(newTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 2), replacementString: "333")

        // Then
        XCTAssertTrue(shouldChange)
    }
    
    func test_textFieldShouldChangeCharactersInRange_inValidFormat() {
        // Given
        let sut = makeSUT()
        let newTextField = UITextField()
        newTextField.text = "Textfield Test"
        
        // When
        let shouldChange = sut.textField(newTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 4), replacementString: "Test")

        // Then
        XCTAssertFalse(shouldChange)
    }

    func test_canPerformAction_rejectsNonPasteActions() {
        let sut = makeSUT()
        XCTAssertFalse(sut.canPerformAction(NSSelectorFromString("copy:"), withSender: nil))
        XCTAssertFalse(sut.canPerformAction(NSSelectorFromString("cut:"), withSender: nil))
    }

    private func makeSUT() -> PSCardCVVInputTextField {
        .init(frame: .zero)
    }
}
