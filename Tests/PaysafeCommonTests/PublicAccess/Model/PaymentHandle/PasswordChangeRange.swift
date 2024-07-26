//
//  PasswordChangeRange.swift
//
//
//  Created by Eduardo Oliveros on 7/25/24.
//

import XCTest
@testable import PaysafeCommon

final class PasswordChangeRangeTests: XCTestCase {
    
    func test_moreThan60Days() {
        XCTAssertEqual(PasswordChangeRange.moreThan60Days.request, PasswordChangeRangeRequest.moreThan60Days)
    }
    
    func test_noChange() {
        XCTAssertEqual(PasswordChangeRange.noChange.request, PasswordChangeRangeRequest.noChange)
    }
    
    func test_duringTransaction() {
        XCTAssertEqual(PasswordChangeRange.duringTransaction.request, PasswordChangeRangeRequest.duringTransaction)
    }
    
    func test_lessThan30Days() {
        XCTAssertEqual(PasswordChangeRange.lessThan30Days.request, PasswordChangeRangeRequest.lessThan30Days)
    }
    
    func test_from30To60Days() {
        XCTAssertEqual(PasswordChangeRange.from30To60Days.request, PasswordChangeRangeRequest.from30To60Days)
    }
}
