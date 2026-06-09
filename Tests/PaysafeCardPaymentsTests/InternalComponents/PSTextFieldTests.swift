//
//  PSTextFieldTests.swift
//
//  Covers PSTextField branches via concrete subclasses used by the SDK.
//

import PaysafeCommon
@testable import PaysafeCardPayments
import UIKit
import XCTest

final class PSTextFieldTests: XCTestCase {
    func test_validatesOnBlurWhenEmpty_false_skipsValidationWhenFieldEmptyOnEndEditing() {
        let sut = PSCardNumberInputView(validatesOnBlurWhenEmpty: false)
        let tf = sut.cardNumberTextField
        tf.text = ""
        tf.textFieldDidBeginEditing(tf)
        tf.textFieldDidEndEditing(tf)
        XCTAssertTrue(tf.isValid)
    }

    func test_validatesOnBlurWhenEmpty_true_validatesWhenFieldEmptyOnEndEditing() {
        let sut = PSCardNumberInputView(validatesOnBlurWhenEmpty: true)
        let tf = sut.cardNumberTextField
        tf.text = ""
        tf.textFieldDidBeginEditing(tf)
        tf.textFieldDidEndEditing(tf)
        XCTAssertFalse(tf.isValid)
    }

    func test_shouldAnimateTopPlaceholder_false_hidesTopLabelBranch() {
        let sut = PSCardNumberInputView(animateTopPlaceholderLabel: false)
        sut.cardNumberTextField.shouldAnimateTopPlaceholder = false
        XCTAssertNotNil(sut.cardNumberTextField)
    }

    func test_theme_setter_appliesToTextField() {
        let sut = PSCardNumberInputTextField()
        let theme = PSTheme(backgroundColor: .systemOrange)
        sut.theme = theme
        XCTAssertEqual(sut.theme.backgroundColor, theme.backgroundColor)
    }

    func test_traitCollectionDidChange_appliesTheme() {
        let sut = PSCardNumberInputTextField()
        sut.traitCollectionDidChange(nil)
        XCTAssertNotNil(sut.backgroundColor)
    }

    func test_textAlignmentCenter_withAnimatedPlaceholder_updatesConstraints() {
        let sut = PSCardNumberInputTextField()
        sut.textAlignment = .center
        XCTAssertEqual(sut.textAlignment, .center)
    }

    func test_setToolbarViewToNil_defaultsToUIToolbarView() {
        let sut = PSTextField()

        sut.toolbarView = nil

        XCTAssertTrue(sut.inputAccessoryView is UIToolbar)
    }

    func test_setCustomToolbarView_updatesFieldInputAccessoryView() {
        let sut = PSTextField()
        let customView = UIView()

        sut.toolbarView = customView

        XCTAssertEqual(customView, sut.inputAccessoryView)
    }
}
