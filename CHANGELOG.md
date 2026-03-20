# Change Log

## [1.2.1] - 2026-03-20
* Align Apple Pay `PaymentResponse` decoding with Payment Hub: `ApplePaymentDataResponse` now only models `header` (`publicKeyHash`, `transactionId`); removed fields (`signature`, `data`, `version`, `decryptedData`, `ephemeralPublicKey`) are no longer decoded. Extra keys in older responses are ignored.

## [1.2.0] - 2026-03-19
* Add optional custom `label` on card input components (card number, cardholder name, expiry, CVV) for localized top label and placeholder text in UIKit and SwiftUI.

## [1.1.0] - 20256-03-10
* Update Cardinal version to 2.2.6-2
* Add `dataCenter` parameter to `Paysafe3DS.Configuration`  

## [1.0.0] - 2025-11-13

_Major release_

### Payment Methods Coverage

- [Apple Pay](https://developer.paysafe.com/en/api-docs/mobile-sdks-payments-api/paysafe-ios-sdk/apple-pay-integration/overview/)
- [Cards](https://developer.paysafe.com/en/api-docs/mobile-sdks-payments-api/paysafe-ios-sdk/card-payments/overview/)
- [Venmo](https://developer.paysafe.com/en/api-docs/mobile-sdks-payments-api/paysafe-ios-sdk/venmo-integration-ios/)
