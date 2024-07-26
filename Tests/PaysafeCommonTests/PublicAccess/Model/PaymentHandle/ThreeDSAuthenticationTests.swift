//
//  ThreeDSAuthenticationTests.swift
//
//
//  Created by Eduardo Oliveros on 7/25/24.
//

import XCTest
@testable import PaysafeCommon

final class ThreeDSAuthenticationTests: XCTestCase {
    
    func test_frictionlessAuthentication() {
        XCTAssertEqual(ThreeDSAuthentication.frictionlessAuthentication.request, ThreeDSAuthenticationRequest.frictionlessAuthentication)
    }
    
    func test_acsChallenge() {
        XCTAssertEqual(ThreeDSAuthentication.acsChallenge.request, ThreeDSAuthenticationRequest.acsChallenge)
    }
    
    func test_avsVerified() {
        XCTAssertEqual(ThreeDSAuthentication.avsVerified.request, ThreeDSAuthenticationRequest.avsVerified)
    }
    
    func test_otherIssuerMethod() {
        XCTAssertEqual(ThreeDSAuthentication.otherIssuerMethod.request, ThreeDSAuthenticationRequest.otherIssuerMethod)
    }
}
