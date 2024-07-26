//
//  File.swift
//  
//
//  Created by Eduardo Oliveros on 7/25/24.
//

import XCTest
@testable import PaysafeCore

final class PSCardExpiryInputTextFieldTests: XCTestCase {
    func test_textFieldShouldChangeCharactersInRange() {
        // Given
        let textfield = PSCardExpiryInputTextField(frame: CGRect.zero)
        let newTextField = UITextField()
        newTextField.text = "Textfield Test"
        
        // When
        let shouldChange = textfield.textField(newTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 2), replacementString: "Te")
        
        // Then
        XCTAssertFalse(shouldChange)
    }
    
    func test_pickerViewSelectedDate() {
        // Given
        let month = 10
        let year = 24
        
        let textfield = PSCardExpiryInputTextField(frame: CGRect.zero)
        
        // When
        textfield.pickerViewSelectedDate(month: month, year: year)
        
        // Then
        XCTAssertEqual(textfield.text, "\(month)" + " / " + "\(year)")
    }
}
