//
//  DateOfBirth.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

/// Date of birth
public struct DateOfBirth: Encodable {
    /// Day
    let day: Int?
    /// Month
    let month: Int?
    /// Year
    let year: Int?

    /// - Parameters:
    ///   - day: Day
    ///   - month: Month
    ///   - year: Year
    public init(
        day: Int? = nil,
        month: Int? = nil,
        year: Int? = nil
    ) {
        self.day = day
        self.month = month
        self.year = year
    }

    /// DateOfBirthRequest
    var request: DateOfBirthRequest {
        DateOfBirthRequest(
            day: day,
            month: month,
            year: year
        )
    }
}
