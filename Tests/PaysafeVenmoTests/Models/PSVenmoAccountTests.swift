//
//  PSVenmoResultTests.swift
//
//
//  Created by Eduardo Oliveros on 6/24/24.
//

import Combine
@testable import PaysafeVenmo
import PaysafeCommon
import XCTest

final class PSVenmoAccountTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_initiate_VenmoAccount_serialize() {
        // Given
        let model = VenmoAccount(email: "emain@test.com", externalID: "externalIdTest", firstName: "firstNameTest", lastName: "lastName", phoneNumber: "601000000", username: "usernameTest", nonce: "test-nonce", type: "credit-card", isDefault: true)
        
        //When
        let serializeModel = model.serialize()
        
        // Then
        
        let decoder = JSONDecoder()
        let jsonData = Data(serializeModel.utf8)
        
        do {
            let venmoAccount = try decoder.decode([String: String].self, from: jsonData)
            XCTAssertEqual(venmoAccount["firstName"], model.firstName)
            XCTAssertEqual(venmoAccount["lastName"], model.lastName)
            XCTAssertEqual(venmoAccount["userName"], "@" + (model.username ?? ""))
            XCTAssertEqual(venmoAccount["phoneNumber"], model.phoneNumber)
            XCTAssertEqual(venmoAccount["externalId"], model.externalID)
        } catch {
            XCTAssertTrue(false, "VenmoAccount should be serialized with expected format")
        }
    }
}
