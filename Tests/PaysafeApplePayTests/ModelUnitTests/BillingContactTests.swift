//
//  BillingContactTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeApplePay
import XCTest

class BillingContactTests: XCTestCase {
    func test_billingContact_encoding() throws {
        // Given
        let addressLines = ["123 Apple Seed St", "Suite 456"]
        let countryCode = "US"
        let email = "john.doed@paysafe.com"
        let locality = "Cupertino"
        let name = "John Appleseed"
        let phone = "408-555-5555"
        let country = "USA"
        let postalCode = "95014"
        let administrativeArea = "CA"

        let billingContact = BillingContact(
            addressLines: addressLines,
            countryCode: countryCode,
            email: email,
            locality: locality,
            name: name,
            phone: phone,
            country: country,
            postalCode: postalCode,
            administrativeArea: administrativeArea
        )

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(billingContact)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

        // Then
        XCTAssertNotNil(json, "Encoded object should be convertible to JSON dictionary.")

        XCTAssertEqual(json?["addressLines"] as? [String], addressLines, "addressLines should be correctly encoded")
        XCTAssertEqual(json?["countryCode"] as? String, countryCode, "countryCode should be correctly encoded")
        XCTAssertEqual(json?["email"] as? String, email, "email should be correctly encoded")
        XCTAssertEqual(json?["locality"] as? String, locality, "locality should be correctly encoded")
        XCTAssertEqual(json?["name"] as? String, name, "name should be correctly encoded")
        XCTAssertEqual(json?["phone"] as? String, phone, "phone should be correctly encoded")
        XCTAssertEqual(json?["country"] as? String, country, "country should be correctly encoded")
        XCTAssertEqual(json?["postalCode"] as? String, postalCode, "postalCode should be correctly encoded")
        XCTAssertEqual(json?["administrativeArea"] as? String, administrativeArea, "administrativeArea should be correctly encoded")
    }

    func test_billingContact_encodingWithNilValues() throws {
        // Given
        let billingContact = BillingContact(
            addressLines: ["123 Apple Seed St"],
            countryCode: nil,
            email: nil,
            locality: nil,
            name: "John Appleseed",
            phone: nil,
            country: nil,
            postalCode: nil,
            administrativeArea: nil
        )

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(billingContact)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

        // Then
        XCTAssertNotNil(json, "Encoded object should be convertible to JSON dictionary.")
        XCTAssertNotNil(json?["addressLines"], "addressLines should always be encoded")
        XCTAssertEqual(json?["name"] as? String, "John Appleseed", "name should always be encoded")

        XCTAssertNil(json?["countryCode"], "countryCode should not be encoded when nil")
        XCTAssertNil(json?["email"], "email should not be encoded when nil")
        XCTAssertNil(json?["locality"], "locality should not be encoded when nil")
        XCTAssertNil(json?["phone"], "phone should not be encoded when nil")
        XCTAssertNil(json?["country"], "country should not be encoded when nil")
        XCTAssertNil(json?["postalCode"], "postalCode should not be encoded when nil")
        XCTAssertNil(json?["administrativeArea"], "administrativeArea should not be encoded when nil")
    }
}
