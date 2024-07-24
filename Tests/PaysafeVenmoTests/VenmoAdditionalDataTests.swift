//
//  VenmoAdditionalDataTests.swift
//
//
//  Created by Eduardo Oliveros on 6/25/24.
//

@testable import PaysafeCommon
@testable import PaysafeVenmo

import XCTest
import Combine
import Foundation

final class VenmoAdditionalDataTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_initialize_additionalData() {
        let consumerId = "test"
        let merchantAccountId = "merchantAccountId"
        
        let model = VenmoAdditionalData(consumerId: consumerId, merchantAccountId: "merchantAccountId")
        
        XCTAssertEqual(model.request.consumerId, consumerId)
        XCTAssertEqual(model.request.merchantAccountId, merchantAccountId)
    }
}
