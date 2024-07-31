//
//  SimulatorTests.swift
//
//
//  Created by Eduardo Oliveros on 7/30/24.
//

@testable import PaysafeCommon
import XCTest

final class SimulatorTests: XCTestCase {
    func test_internalValue() {
        // Given
        let simulator = SimulatorType.internalSimulator
        
        // Then
        XCTAssertEqual(simulator.rawValue, "INTERNAL")
    }
    
    func test_externalValue() {
        // Given
        let simulator = SimulatorType.externalSimulator
        
        // Then
        XCTAssertEqual(simulator.rawValue, "EXTERNAL")
    }
}
