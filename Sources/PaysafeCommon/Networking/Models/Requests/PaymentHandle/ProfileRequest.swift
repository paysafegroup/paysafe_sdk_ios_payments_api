//
//  ProfileRequest.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

typealias LocaleRequest = InternalLocale
typealias GenderRequest = Gender

/// ProfileRequest
struct ProfileRequest: Encodable {
    /// First name
    let firstName: String?
    /// Last name
    let lastName: String?
    /// Locale
    let locale: LocaleRequest?
    /// Merchant customer id
    let merchantCustomerId: String?
    /// Date of birth
    let dateOfBirth: DateOfBirthRequest?
    /// Email
    let email: String?
    /// Phone
    let phone: String?
    /// Mobile
    let mobile: String?
    /// Gender
    let gender: GenderRequest?
    /// Nationality
    let nationality: String?
    /// Identity documents
    let identityDocuments: [IdentityDocumentRequest]?
}
