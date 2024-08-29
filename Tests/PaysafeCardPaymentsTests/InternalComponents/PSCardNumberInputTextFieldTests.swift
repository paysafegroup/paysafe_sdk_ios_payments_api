//
//  PSCardNumberInputTextFieldTests.swift
//
//
//  Created by Eduardo Oliveros on 7/25/24.
//

import PaysafeCommon
@testable import PaysafeCardPayments
import XCTest

final class PSCardNumberInputTextFieldTests: XCTestCase {
    func test_textFieldShouldChangeCharactersInRange() {
        // Given
        let textfield = PSCardNumberInputTextField(frame: CGRect.zero)
        let newTextField = UITextField()
        newTextField.text = "3333"
        
        // When
        let shouldChange = textfield.textField(newTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 2), replacementString: "55")
        
        // Then
        XCTAssertTrue(shouldChange)
    }
    
    func test_textFieldShouldChangeCharactersInRange_Text() {
        // Given
        let textfield = PSCardNumberInputTextField(frame: CGRect.zero)
        let newTextField = UITextField()
        newTextField.text = "Title "
        
        // When
        let shouldChange = textfield.textField(newTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 2), replacementString: "TEST")
        
        // Then
        XCTAssertFalse(shouldChange)
    }
}
