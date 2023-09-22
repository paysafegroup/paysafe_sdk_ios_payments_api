//
//  ProfileRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

typealias LocaleRequest = InternalLocale

/// ProfileRequest
struct ProfileRequest: Encodable {
    /// First name
    let firstName: String?
    /// Last name
    let lastName: String?
    /// Locale
    let locale: String?
    /// Merchant customer id
    let merchantCustomerId: LocaleRequest?
    /// Date of birth
    let dateOfBirth: DateOfBirthRequest?
    /// Email
    let email: String?
    /// Phone
    let phone: String?
    /// Mobile
    let mobile: String?
    /// Gender
    let gender: String?
    /// Nationality
    let nationality: String?
    /// Identity documents
    let identityDocuments: [IdentityDocumentRequest]?
}
