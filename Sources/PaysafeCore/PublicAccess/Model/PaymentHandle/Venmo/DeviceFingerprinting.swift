//
//  DeviceFingerprinting.swift
//
//
//  Created by Eduardo Oliveros on 5/30/24.
//

import Foundation

/// DeviceFingerprinting
public struct DeviceFingerprinting: Encodable {
    /// threatMetrixSessionId
    public let threatMetrixSessionId: String
    
    public init(threatMetrixSessionId: String) {
        self.threatMetrixSessionId = threatMetrixSessionId
    }
}
