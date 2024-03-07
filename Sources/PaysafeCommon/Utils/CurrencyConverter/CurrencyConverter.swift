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
            .bhd: 3,
            .byr: 0,
            .jpy: 0,
            .jod: 3,
            .krw: 0,
            .kwd: 3,
            .lyd: 3,
            .omr: 3,
            .pyg: 0,
            .tnd: 3,
            .vnd: 0
        ]
    }
}
