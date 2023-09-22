//
//  CurrencyConverter.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

public final class CurrencyConverter {
    /// Multiplier map
    private var multiplierMap: [PSCurrency: Int]

    /// - Parameters:
    ///   - conversionRules: Conversion rules for each currency
    public init(conversionRules: [PSCurrency: Int]) {
        multiplierMap = conversionRules
    }

    /// Method to convert minor amount based on the currency.
    public func convert(amount: Int, forCurrency currency: String) -> Double {
        guard let psCurrency = PSCurrency(rawValue: currency),
              let power = multiplierMap[psCurrency] else {
            print("Currency doesn't need conversion: \(currency)")
            return Double(amount) / pow(10.0, 2)
        }
        return Double(amount) / pow(10.0, Double(power))
    }
}

/// Default multiplier map
public extension CurrencyConverter {
    static func defaultCurrenciesMap() -> [PSCurrency: Int] {
        [
            .BHD: 3,
            .BYR: 0,
            .JPY: 0,
            .JOD: 3,
            .KRW: 0,
            .KWD: 3,
            .LYD: 3,
            .OMR: 3,
            .PYG: 0,
            .TND: 3,
            .VND: 0
        ]
    }
}
