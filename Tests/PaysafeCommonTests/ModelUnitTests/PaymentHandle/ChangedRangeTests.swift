//
//  ChangedRangeTests.swift
//
//
//  Created by Eduardo Oliveros on 7/29/24.
//

@testable import PaysafeCommon
import XCTest

class ChangedRangeTests: XCTestCase {
    func test_duringTransaction() {
        //Given
        let range = ChangedRange.duringTransaction
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, ChangedRangeRequest.duringTransaction)
    }
    
    func test_lessThan30Days() {
        //Given
        let range = ChangedRange.lessThan30Days
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, ChangedRangeRequest.lessThan30Days)
    }
    
    func test_from30To60Days() {
        //Given
        let range = ChangedRange.from30To60Days
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, ChangedRangeRequest.from30To60Days)
    }
    
    func test_moreThan60Days() {
        //Given
        let range = ChangedRange.moreThan60Days
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, ChangedRangeRequest.moreThan60Days)
    }
}

