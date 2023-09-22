//
//  SavedCardsResponse.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

/// SavedCardsResponse
struct SavedCardsResponse: Decodable {
    /// Id
    let id: String
    /// Time to live seconds
    let timeToLiveSeconds: Int
    /// Status
    let status: String
    /// Single use customer token
    let singleUseCustomerToken: String
    /// Locale
    let locale: String
    /// First name
    let firstName: String
    /// Middle name
    let middleName: String
    /// Last name
    let lastName: String
    /// Date of birth
    let dateOfBirth: DateOfBirth
    /// Email
    let email: String
    /// Phone
    let phone: String
    /// IP
    let ip: String
    /// Nationality
    let nationality: String
    /// Addresses
    let addresses: [Address]
    /// Payment handles
    let paymentHandles: [PaymentHandle]
    /// Customer id
    let customerId: String
}
