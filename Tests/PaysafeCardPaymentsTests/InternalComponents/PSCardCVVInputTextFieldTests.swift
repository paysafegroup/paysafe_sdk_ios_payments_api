//
//  PSCardCVVInputTextFieldTests.swift
//
//
//  Created by Eduardo Oliveros on 7/25/24.
//

import XCTest
@testable import PaysafeCardPayments

final class PSCardCVVInputTextFieldTests: XCTestCase {
    func test_textFieldShouldChangeCharactersInRange_ValidFormat() {
        // Given
        let textfield = PSCardCVVInputTextField(frame: CGRect.zero)
        let newTextField = UITextField()
        newTextField.text = "333"
        
        // When
        let shouldChange = textfield.textField(newTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 2), replacementString: "333")
        
        // Then
        XCTAssertTrue(shouldChange)
    }
    
    func test_textFieldShouldChangeCharactersInRange_inValidFormat() {
        // Given
        let textfield = PSCardCVVInputTextField(frame: CGRect.zero)
        let newTextField = UITextField()
        newTextField.text = "Textfield Test"
        
        // When
        let shouldChange = textfield.textField(newTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 4), replacementString: "Test")
        
        // Then
        XCTAssertFalse(shouldChange)
    }
}
