//
//  EventType.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Type of the logging event. Permitted Values are (ERROR, CONVERSION, WARN)
enum EventType: String, Encodable {
    /// ERROR type
    case error = "ERROR"
    /// CONVERSION type
    case conversion = "CONVERSION"
    /// WARN type
    case warn = "WARN"
}
