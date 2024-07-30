//
//  AuthenticationMethodTests.swift
//
//
//  Created by Eduardo Oliveros on 7/29/24.
//

@testable import PaysafeCommon
import XCTest

class AuthenticationMethodTests: XCTestCase {
    func test_thirdPartyAuthentication() {
        //Given
        let range = AuthenticationMethod.thirdPartyAuthentication
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, AuthenticationMethodRequest.thirdPartyAuthentication)
    }
    
    func test_noLogin() {
        //Given
        let range = AuthenticationMethod.noLogin
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, AuthenticationMethodRequest.noLogin)
    }
    
    func test_internalCredentials() {
        //Given
        let range = AuthenticationMethod.internalCredentials
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, AuthenticationMethodRequest.internalCredentials)
    }
    
    func test_federatedId() {
        //Given
        let range = AuthenticationMethod.federatedId
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, AuthenticationMethodRequest.federatedId)
    }
    
    func test_issuerCredentials() {
        //Given
        let range = AuthenticationMethod.issuerCredentials
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, AuthenticationMethodRequest.issuerCredentials)
    }
    
    func test_fidoAuthenticator() {
        //Given
        let range = AuthenticationMethod.fidoAuthenticator
        
        // When
        let request = range.request
        
        // Then
        
        XCTAssertEqual(request, AuthenticationMethodRequest.fidoAuthenticator)
    }
}
