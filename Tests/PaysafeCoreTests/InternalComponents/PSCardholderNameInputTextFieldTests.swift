//
//  File.swift
//  
//
//  Created by Eduardo Oliveros on 7/25/24.
//

import XCTest
@testable import PaysafeCore

final class PSCardholderNameInputTextFieldTests: XCTestCase {
    func test_textFieldShouldChangeCharactersInRange() {
        // Given
        let textfield = PSCardholderNameInputTextField(frame: CGRect.zero)
        let newTextField = UITextField()
        newTextField.text = "Textfield Test"
        
        // When
        let shouldChange = textfield.textField(newTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 2), replacementString: "Text")
        
        // Then
        XCTAssertTrue(shouldChange)
    }
}
