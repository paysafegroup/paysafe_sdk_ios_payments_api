//
//  RequestorChallengePreferenceTests.swift
//
//
//  Created by Eduardo Oliveros on 7/29/24.
//

@testable import PaysafeCommon
import XCTest

class RequestorChallengePreferenceTests: XCTestCase {
    func test_challengeMandated() {
        //Given
        let range = RequestorChallengePreference.challengeMandated
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, RequestorChallengePreferenceRequest.challengeMandated)
    }
    
    func test_challengeRequested() {
        //Given
        let range = RequestorChallengePreference.challengeRequested
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, RequestorChallengePreferenceRequest.challengeRequested)
    }
    
    func test_noPreference() {
        //Given
        let range = RequestorChallengePreference.noPreference
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, RequestorChallengePreferenceRequest.noPreference)
    }
}
