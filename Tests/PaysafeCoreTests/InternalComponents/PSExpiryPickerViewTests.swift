//
//  PSExpiryPickerViewTests.swift
//  
//
//  Created by Eduardo Oliveros on 7/25/24.
//

import PaysafeCommon
@testable import PaysafeCore
import XCTest

final class PSExpiryPickerViewTests: XCTestCase, PSExpiryPickerViewDelegate {
    var sut: PaysafeSDK!
    var text = ""
    
    override func setUp() {
        super.setUp()
        sut = PaysafeSDK.shared
    }

    override func tearDown() {
        sut.psAPIClient = nil
        sut = nil
        super.tearDown()
    }
    
    func test_init() {
        let data = try! NSKeyedArchiver.archivedData(withRootObject: "", requiringSecureCoding: false)
        let coder = try! NSKeyedUnarchiver(forReadingFrom: data)
        let view = PSExpiryPickerView(coder: coder)
        
        XCTAssertNotNil(view)
    }
    
    func test_didBeginEditing() {
        let view = PSExpiryPickerView()
        view.psDelegate = self
        view.didBeginEditing()
        let calendarText = String(Calendar.current.component(.month, from: Date())) + String(Calendar.current.component(.year, from: Date()))
        
        XCTAssertEqual(text, calendarText)
    }
    
    func test_pickerView() {
        let view = PSExpiryPickerView()
        view.psDelegate = self
        view.pickerView(UIPickerView(), didSelectRow: 0, inComponent: 0)
        
        let newText = String(Calendar.current.component(.month, from: Date())) + String(Calendar.current.component(.year, from: Date()))
        
        XCTAssertEqual(text, newText)
    }
    
    func pickerViewSelectedDate(month: Int, year: Int) {
        text = String(month) + String(year)
    }
}
