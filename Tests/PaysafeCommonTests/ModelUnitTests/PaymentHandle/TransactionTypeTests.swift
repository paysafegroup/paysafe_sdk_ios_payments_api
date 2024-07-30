//
//  TransactionTypeTests.swift
//  
//
//  Created by Eduardo Oliveros on 7/29/24.
//

@testable import PaysafeCommon
import XCTest

class TransactionTypeTests: XCTestCase {
    func test_payment() {
        //Given
        let range = TransactionType.payment
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, TransactionTypeRequest.payment)
    }
    
    func test_standaloneCredit() {
        //Given
        let range = TransactionType.standaloneCredit
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, TransactionTypeRequest.standaloneCredit)
    }
    
    func test_originalCredit() {
        //Given
        let range = TransactionType.originalCredit
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, TransactionTypeRequest.originalCredit)
    }
    
    func test_verification() {
        //Given
        let range = TransactionType.verification
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, TransactionTypeRequest.verification)
    }
}
