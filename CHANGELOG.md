# Change Log

## [3.0.1] - 2026-11-09

_CocoaPods Venmo alignment with Braintree DataCollector._

### Venmo

- CocoaPods **`PaysafeVenmo`** now also depends on **`Braintree/DataCollector`** (`>= 7.13.0`, `< 8.0.0`), matching Swift Package Manager.

## [3.0.0] - 2026-10-27

_Venmo app switch on Braintree 7, with device-data collection._

### API notes (may require code updates)

- Minimum iOS version is **15.0**.
- Braintree iOS is **7.13.0** or later and below **8.0.0**. Swift Package Manager also links **BraintreeDataCollector**.
- **`PSVenmoContext.setURLScheme(scheme:)`** is removed. Call **`PSVenmoContext.configureAppSwitchReturn(universalLink:returnURLScheme:)`** at launch with an HTTPS Universal Link (path contains `braintree-payments`) and the custom URL scheme.
- Forward Universal Links to **`PSVenmoContext.openURL(url:)`**. Keep **`setURLContexts(contexts:)`** for the custom scheme.
- **`PSError.venmoAppNotFound`** / **`PSErrorCode.venmoAppIsNotInstalled`** are removed. A missing or invalid Universal Link fails with **`PSError.venmoInvalidUniversalLinkPassed`** (**9292**, **`venmoInvalidUniversalLink`**).
- The Venmo app is optional. Braintree uses the web fallback when the app cannot be presented.

### Venmo

- Device data is collected during **`tokenize`** and sent as `payment_method_deviceData`. Empty collection sends `{"correlation_id":"<correlation id>"}`.
- When the payment-handle gateway response includes **`brainTreeCustomerId`**, the SDK skips the Venmo app switch and sends device data only. **`clientMetadataId`** is the Braintree risk correlation id.
- Venmo payment-handle requests include **`mobileSdk: true`**.
- Available payment methods load from **`GET /paymenthub/v1/configuration`**. 

## [1.4.0] - 2026-10-12

_Optional CVV for saved-card tokenization._

### Card payments

- **`PSCardTokenizeOptions.optional`** (default **`false`**): on saved-card tokenization (`singleUseCustomerToken` and `paymentTokenFrom`), merchants may omit CVV collection; when not provided, **`cvv`** is omitted from the payment-handle request. Ignored for new-card flows; CVV remains required when **`optional`** is **`false`**.
- **`PSCardForm.cvvOptional`**: when **`true`**, **`onCardFormUpdate`** treats an empty CVV as valid; set for saved-card optional CVV (also applied from tokenize options when calling **`tokenize`**).
- **`CardRequest.cvv`**: optional (`String?`); **`nil`** values are not encoded in the JSON payload.

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
