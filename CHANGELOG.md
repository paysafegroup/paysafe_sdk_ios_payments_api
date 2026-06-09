# Change Log

## [1.3.0] - 2026-06-08

_Card form improvements and related fixes._

### API notes (may require code updates)

- **`PSCardFieldInputEvent`**: added `.blur`. Exhaustive `switch`es on this enum must include the new case.

### Card payments

- Emit **blur** alongside **focus** from card field **`onEvent`** callbacks; **`PSTextField`** end-editing always reports focus loss, including when the field text is empty.
- **`PSCardForm.resetOnTokenize`** (default **`true`**): set to **`false`** to avoid clearing fields after tokenization (e.g. retry flows).
- **`PSCardForm.tokenize`**: outer Combine **`receiveValue`** uses **`[weak self]`** to avoid retaining the form.
- **`PSTextField.validatesOnBlurWhenEmpty`** (default **`true`**): when **`false`**, empty fields skip validation on blur and return to the normal border.
- **`PSCardInputView.hasText()`**: raw text presence (distinct from validated **`isEmpty()`**).
- **`PSCardNumberInputTextField`**: **`resetTextField()`** sets **`cardBrand`** to **`.unknown`** so the network icon does not persist after reset.
- **Paste** enabled on the expiry **text** field (same pattern as card number and CVV).
- **`CardRequest`, `PSCardForm`**: make **`holderName`** optional, fixed blocking tokenization when not provided
- **`PSTextField`**: expose **`toolbarView`** for clients allowing them to provide custom view 
- Documentation: correct **`reset()`** descriptions on card views; spelling fixes (**`responsible`**, **“reference”**) in module and tokenize option docs.

### Legal

- **LICENSE**: update licence document

## [1.2.1] - 2026-03-20
* Align Apple Pay `PaymentResponse` decoding with Payment Hub: `ApplePaymentDataResponse` now only models `header` (`publicKeyHash`, `transactionId`); removed fields (`signature`, `data`, `version`, `decryptedData`, `ephemeralPublicKey`) are no longer decoded. Extra keys in older responses are ignored.

## [1.2.0] - 2026-03-19
* Add optional custom `label` on card input components (card number, cardholder name, expiry, CVV) for localized top label and placeholder text in UIKit and SwiftUI.

## [1.1.0] - 2026-03-10
* Update Cardinal version to 2.2.6-2
* Add `dataCenter` parameter to `Paysafe3DS.Configuration`  

## [1.0.0] - 2025-11-13

_Major release_

### Payment Methods Coverage

- [Apple Pay](https://developer.paysafe.com/en/api-docs/mobile-sdks-payments-api/paysafe-ios-sdk/apple-pay-integration/overview/)
- [Cards](https://developer.paysafe.com/en/api-docs/mobile-sdks-payments-api/paysafe-ios-sdk/card-payments/overview/)
- [Venmo](https://developer.paysafe.com/en/api-docs/mobile-sdks-payments-api/paysafe-ios-sdk/venmo-integration-ios/)
