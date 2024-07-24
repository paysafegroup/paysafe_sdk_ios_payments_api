//
//  Profile.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// User profile
public struct Profile: Encodable {
    /// First name
    public let firstName: String?
    /// Last name
    public let lastName: String?
    /// Locale
    let locale: InternalLocale?
    /// Merchant customer id
    public let merchantCustomerId: String?
    /// Date of birth
    public let dateOfBirth: DateOfBirth?
    /// Email
    public let email: String?
    /// Phone
    public let phone: String?
    /// Mobile
    public let mobile: String?
    /// Gender
    public let gender: Gender?
    /// Nationality
    public let nationality: String?
    /// Identity documents
    public let identityDocuments: [IdentityDocument]?

    /// - Parameters:
    ///   - firstName: First name
    ///   - lastName: Last name
    ///   - locale: Locale
    ///   - merchantCustomerId: Merchant customer id
    ///   - dateOfBirth: Date of birth
    ///   - email: Email
    ///   - phone: Phone
    ///   - mobile: Mobile phone
    ///   - gender: Gender
    ///   - nationality: Nationality
    ///   - identityDocuments: Identity documents
    public init(
        firstName: String?,
        lastName: String?,
        locale: InternalLocale?,
        merchantCustomerId: String?,
        dateOfBirth: DateOfBirth?,
        email: String?,
        phone: String?,
        mobile: String?,
        gender: Gender?,
        nationality: String?,
        identityDocuments: [IdentityDocument]?
    ) {
        self.merchantCustomerId = merchantCustomerId
        self.locale = locale
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.dateOfBirth = dateOfBirth
        self.mobile = mobile
        self.gender = gender
        self.nationality = nationality
        self.identityDocuments = identityDocuments
    }

    /// ProfileRequest
    var request: ProfileRequest {
        ProfileRequest(
            firstName: firstName,
            lastName: lastName,
            locale: locale,
            merchantCustomerId: merchantCustomerId,
            dateOfBirth: dateOfBirth?.request,
            email: email,
            phone: phone,
            mobile: mobile,
            gender: gender,
            nationality: nationality,
            identityDocuments: identityDocuments?.map(\.request) ?? nil
        )
    }
}
