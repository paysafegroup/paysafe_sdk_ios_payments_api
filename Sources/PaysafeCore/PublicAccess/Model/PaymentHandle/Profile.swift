//
//  Profile.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Customer profile
public struct Profile: Encodable {
    /// First name
    let firstName: String?
    /// Last name
    let lastName: String?
    /// Email
    let email: String?
    /// Phone
    let phone: String?
    /// Cell phone
    let cellPhone: String?

    /// - Parameters:
    ///   - firstName: First name
    ///   - lastName: Last name
    ///   - email: Email
    ///   - phone: Phone
    ///   - cellPhone: Cell phone
    public init(
        firstName: String?,
        lastName: String?,
        email: String?,
        phone: String?,
        cellPhone: String?
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.cellPhone = cellPhone
    }

    /// ProfileRequest
    var request: ProfileRequest {
        ProfileRequest(
            firstName: firstName,
            lastName: lastName,
            locale: nil,
            merchantCustomerId: nil,
            dateOfBirth: nil,
            email: email,
            phone: phone,
            mobile: cellPhone,
            gender: nil,
            nationality: nil,
            identityDocuments: []
        )
    }
}
