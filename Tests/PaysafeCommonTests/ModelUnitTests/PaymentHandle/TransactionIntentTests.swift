//
//  TransactionIntentTests.swift
//
//
//  Created by Eduardo Oliveros on 7/29/24.
//

@testable import PaysafeCommon
import XCTest

class TransactionIntentTests: XCTestCase {
    func test_goodsOrServicePurchase() {
        //Given
        let range = TransactionIntent.goodsOrServicePurchase
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, TransactionIntentRequest.goodsOrServicePurchase)
    }
    
    func test_checkAcceptance() {
        //Given
        let range = TransactionIntent.checkAcceptance
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, TransactionIntentRequest.checkAcceptance)
    }
    
    func test_accountFunding() {
        //Given
        let range = TransactionIntent.accountFunding
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, TransactionIntentRequest.accountFunding)
    }
    
    func test_quasiCashTransaction() {
        //Given
        let range = TransactionIntent.quasiCashTransaction
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, TransactionIntentRequest.quasiCashTransaction)
    }
    
    func test_prepaidActivation() {
        //Given
        let range = TransactionIntent.prepaidActivation
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, TransactionIntentRequest.prepaidActivation)
    }
}
