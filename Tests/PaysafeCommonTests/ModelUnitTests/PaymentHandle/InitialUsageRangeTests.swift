//
//  InitialUsageRangeTests.swift
//
//
//  Created by Eduardo Oliveros on 7/29/24.
//

@testable import PaysafeCommon
import XCTest

class InitialUsageRangeTests: XCTestCase {
    func test_duringTransaction() {
        //Given
        let range = InitialUsageRange.currentTransaction
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, InitialUsageRangeRequest.currentTransaction)
    }
    
    func test_lessThan30Days() {
        //Given
        let range = InitialUsageRange.lessThan30Days
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, InitialUsageRangeRequest.lessThan30Days)
    }
    
    func test_from30To60Days() {
        //Given
        let range = InitialUsageRange.from30To60Days
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, InitialUsageRangeRequest.from30To60Days)
    }
    
    func test_moreThan60Days() {
        //Given
        let range = InitialUsageRange.moreThan60Days
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, InitialUsageRangeRequest.moreThan60Days)
    }
}
