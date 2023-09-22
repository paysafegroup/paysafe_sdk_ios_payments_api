//
//  TravelDetails.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

public struct TravelDetails: Encodable {
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

    /// - Parameters:
    ///   - isAirTravel: Is air travel
    ///   - airlineCarrier: Airline carrier
    ///   - departureDate: Departure date
    ///   - destination: Destination
    ///   - origin: Origin
    ///   - passengerFirstName: Passenger first name
    ///   - passengerLastName: Passenger last name
    public init(
        isAirTravel: Bool,
        airlineCarrier: String,
        departureDate: String,
        destination: String,
        origin: String,
        passengerFirstName: String,
        passengerLastName: String
    ) {
        self.isAirTravel = isAirTravel
        self.airlineCarrier = airlineCarrier
        self.departureDate = departureDate
        self.destination = destination
        self.origin = origin
        self.passengerFirstName = passengerFirstName
        self.passengerLastName = passengerLastName
    }

    /// TravelDetailsRequest
    var request: TravelDetailsRequest {
        TravelDetailsRequest(
            isAirTravel: isAirTravel,
            airlineCarrier: airlineCarrier,
            departureDate: departureDate,
            destination: destination,
            origin: origin,
            passengerFirstName: passengerFirstName,
            passengerLastName: passengerLastName
        )
    }
}
