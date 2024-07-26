//
//  File.swift
//  
//
//  Created by Eduardo Oliveros on 7/25/24.
//

import XCTest
@testable import PaysafeCommon

class BillingDetailsTests: XCTestCase {
    func test_request() {
        // Given
        let country = "US"
        let zip = "32256"
        let state = "FL"
        let city = "Jacksonvillle"
        let street = "5335 Gate Parkway Fourth Floor"
        let phone = ""
        let nickname = "John Doe"
        
        // When
        let details = BillingDetails(country: country, zip: zip, state: state, city: city, street: street, street1: nil, street2: nil, phone: phone, nickName: nickname)
        
        let request = details.request
        
        // Then
        XCTAssertEqual(request.country, country)
        XCTAssertEqual(request.zip, zip)
        XCTAssertEqual(request.state, state)
        XCTAssertEqual(request.city, city)
        XCTAssertEqual(request.street, street)
        XCTAssertEqual(request.phone, phone)
        XCTAssertEqual(request.nickName, nickname)
    }
}
