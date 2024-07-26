//
//  PSJailbreakChecker.swift
//
//
//  Created by Eduardo Oliveros on 7/25/24.
//

import XCTest
@testable import PaysafeCommon

final class PSJailbreakCheckerTests: XCTestCase {
    func test_isJailbroken() {
        XCTAssertFalse(PSJailbreakChecker.isJailbroken())
    }
}
