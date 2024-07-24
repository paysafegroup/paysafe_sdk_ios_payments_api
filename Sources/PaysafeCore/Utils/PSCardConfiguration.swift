//
//  PSCardConfiguration.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation
#if canImport(PaysafeCommon)
import PaysafeCommon
#endif

enum PSCardConfiguration {
    /// Make card number display text
    ///
    /// - Parameters:
    ///   - text: Card number string
    ///   - separator: Separator string
    static func makeCardNumberDisplayText(for text: String?, with separator: String) -> NSAttributedString {
        guard let text else { return NSAttributedString() }
        let digits = PSCardUtils.stripNonDigitCharacters(from: text)
        var formattedText = String()
        var currentIndex = digits.startIndex

        PSCardUtils.cardNumberFormat(digits).forEach { groupLength in
            let endIndex = digits.index(
                currentIndex,
                offsetBy: groupLength,
                limitedBy: digits.endIndex
            ) ?? digits.endIndex

            formattedText.append(contentsOf: digits[currentIndex..<endIndex])
            endIndex < digits.endIndex ? formattedText.append(separator) : nil
            currentIndex = endIndex
        }

        return NSAttributedString(string: formattedText)
    }

    /// Make card expiry date display text
    ///
    /// - Parameters:
    ///   - text: Expiry date string
    static func makeCardExpiryDateDisplayText(for text: String?) -> NSAttributedString {
        guard var text else { return NSAttributedString() }
        let digits = PSCardUtils.stripNonDigitCharacters(from: text)

        switch digits.count {
        case 1:
            guard let firstDigit = Int(digits) else { break }
            text = (2...9).contains(firstDigit) ? "0\(firstDigit)" : "\(firstDigit)"
        case 2:
            text = digits
        case 3:
            text = digits.prefix(2) + " / " + digits.suffix(1)
        case 4:
            text = digits.prefix(2) + " / " + digits.suffix(2)
        default:
            break
        }

        return NSAttributedString(string: text)
    }
}
