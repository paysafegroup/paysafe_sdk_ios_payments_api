//
//  CreatedRangeTests.swift
//
//
//  Created by Eduardo Oliveros on 7/29/24.
//

@testable import PaysafeCommon
import XCTest

class CreatedRangeTests: XCTestCase {
    func test_duringTransaction() {
        //Given
        let range = CreatedRange.duringTransaction
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, CreatedRangeRequest.duringTransaction)
    }
    
    func test_noAccount() {
        //Given
        let range = CreatedRange.noAccount
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, CreatedRangeRequest.noAccount)
    }
    
    func test_lessThan30Days() {
        //Given
        let range = CreatedRange.lessThan30Days
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, CreatedRangeRequest.lessThan30Days)
    }
    
    func test_from30To60Days() {
        //Given
        let range = CreatedRange.from30To60Days
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, CreatedRangeRequest.from30To60Days)
    }
    
    func test_moreThan60Days() {
        //Given
        let range = CreatedRange.moreThan60Days
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, CreatedRangeRequest.moreThan60Days)
    }
}
