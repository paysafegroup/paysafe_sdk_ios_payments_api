//
//  TravelDetailsResponse.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// TravelDetailsResponse
struct TravelDetailsResponse: Decodable {
    /// Is air travel
    let isAirTravel: Bool?
    /// Airline carrier
    let airlineCarrier: String?
    /// Departure date
    let departureDate: String?
    /// Destination
    let destination: String?
    /// Origin
    let origin: String?
    /// Passenger first name
    let passengerFirstName: String?
    /// Passenger last name
    let passengerLastName: String?
}
