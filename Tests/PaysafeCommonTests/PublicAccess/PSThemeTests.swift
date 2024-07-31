//
//  File.swift
//  
//
//  Created by Eduardo Oliveros on 7/25/24.
//

import XCTest
@testable import PaysafeCommon

final class PSThemeTests: XCTestCase {
    func test_defaultFocusedBorderColor() {
        // Given
        let theme = PSTheme()
        
        // Then
        XCTAssertNotNil(theme.backgroundColor)
        XCTAssertNotNil(theme.borderColor)
        XCTAssertNotNil(theme.focusedBorderColor)
        XCTAssertNotNil(theme.errorColor)
        XCTAssertNotNil(theme.textInputColor)
        XCTAssertNotNil(theme.placeholderColor)
        XCTAssertNotNil(theme.hintColor)
        XCTAssertNotNil(theme.textInputFont)
        XCTAssertNotNil(theme.placeholderFont)
        XCTAssertNotNil(theme.hintFont)
        XCTAssertEqual(theme.borderCornerRadius, 0.0)

        let view = UIView()
        view.backgroundColor = UIColor.defaultBackgroundColor
        XCTAssertTrue(view.backgroundColor != .white)
        view.backgroundColor = UIColor.defaultBorderColor
        XCTAssertTrue(view.backgroundColor != .white)
        view.backgroundColor = UIColor.defaultFocusedBorderColor
        XCTAssertTrue(view.backgroundColor != .white)
        view.backgroundColor = UIColor.defaultErrorColor
        XCTAssertTrue(view.backgroundColor != .white)
        view.backgroundColor = UIColor.defaultTextInputColor
        XCTAssertTrue(view.backgroundColor != .white)
        view.backgroundColor = UIColor.defaultPlaceholderColor
        XCTAssertTrue(view.backgroundColor != .white)
        view.backgroundColor = UIColor.defaultHintColor
        XCTAssertTrue(view.backgroundColor != .white)
    }
}
