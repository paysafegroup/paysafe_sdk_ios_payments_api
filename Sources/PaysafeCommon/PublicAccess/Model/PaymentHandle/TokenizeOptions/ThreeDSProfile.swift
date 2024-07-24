//
//  ThreeDSProfile.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// ThreeDS profile
public struct ThreeDSProfile: Encodable {
    /// Email
    public let email: String?
    /// Phone
    public let phone: String?
    /// Cell phone
    public let cellPhone: String?

    /// - Parameters:
    ///   - email: End date
    ///   - phone: Phone
    ///   - cellPhone: Cell phone
    public init(
        email: String? = nil,
        phone: String? = nil,
        cellPhone: String? = nil
    ) {
        self.email = email
        self.phone = phone
        self.cellPhone = cellPhone
    }
}
