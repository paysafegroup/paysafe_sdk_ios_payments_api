Paysafe Payments API iOS SDK

## Table of contents

* [Table of contents](#table-of-contents)
* [Overview](#overview)
* [Setup](#setup)
* [Error Object](#callback-error-object-signature)
* [Cards Payments](#card-payments)
* [Google Pay](#google-pay)
* [Venmo](#venmo)
* [Examples](#examples)

## Overview
The Paysafe iOS SDK seamlessly integrates into your mobile app, offering flexibility and full customization.

It ensures data security and PCI compliance while allowing you to design the entire user experience according to your app’s requirements. The SDK manages sensitive payment fields such as card number, CVV, expiry date, year, and month, prioritizing data and PCI security.

Paysafe Group handles the user input and storage of the data. Paysafe iOS SDK uses the [Payment API](https://developer.paysafe.com/en/payments-api/) REST APIs to handle the payment. The SDK is built with an idiomatic and modular approach, ensuring a smooth implementation experience.


### Advantages
- Paysafe native SDK may provide better PCI scope because of how Paysafe collects the card data right from within the mobile app. Please consult with your Qualified Security Assessor to determine your PCI level.
- Extensive customization options enable you to customize payment forms that match your mobile app design. Create as many translated or localized versions of your payment form as required.
- Embeds naturally and remains invisible.
- Supports processing payments with 3D Secure-enabled cards.
- No redirection to an external webpage for 3DS is required.
- Supports native iOS Platform SCA authentication.

### Payment Methods
- Card payments
- Apple Pay
- Venmo

### Before you begin

Contact your business relationship manager or email [Integrations Support](mailto:integrations@paysafe.com) for your Business Portal credentials.
To obtain the Secret API key from the Business Portal:
1. Log in to the Merchant Portal. 
2. Go to Developer > API Keys. 
3. For the Secret Key, you are required to authenticate once more. 
4. When the key is revealed, click the Copy icon to copy the API key. 
5. Your API key will have the format username:password, for example:

   `MerchantXYZ:B-tst1-0-51ed39e4-312d02345d3f123120881dff9bb4020a89e8ac44cdfdcecd702151182fdc952272661d290ab2e5849e31bb03deede9`

Note:
- Use the same API key for all payment methods. 
- The API key is case-sensitive and sent using HTTP Basic Authentication.

For more information, see [Authentication](https://developer.paysafe.com/en/support/reference-information/authentication/).

### Integrating the iOS SDK
The Paysafe iOS SDK is open source and includes a demo for testing the various functionalities. It is compatible with apps supporting iOS 14 or above.

To integrate the Paysafe Payments API iOS SDK:

#### Swift Package Manager

**Step 1** In Xcode, select File > Add Packages… and Enter https://github.com/paysafegroup/paysafe_sdk_ios_payments_api as the repository URL and select the latest version number.

**Step 2**. Tick the checkboxes for the specific Paysafe libraries you wish to include. 

**Step 3**. If you look at your app target, you will see that the Paysafe libraries you chose are automatically linked as a framework to your app (see General > Frameworks, Libraries, and Embedded Content). 

```swift
// In your Swift file
import PaysafeCardPayments
import PaysafeVenmo
import PaysafeApplePay
import Paysafe3DS
                                
```

#### CocoaPods
```swift

// Add in your Podfile
pod 'PaysafePaymentsSDK'

// Or you can import only a single module
pod 'PaysafePaymentsSDK/PaysafeCardPayments'
pod 'PaysafePaymentsSDK/PaysafeVenmo'
pod 'PaysafePaymentsSDK/PaysafeApplePay'
pod 'PaysafePaymentsSDK/Paysafe3DS'

// In your Swift file
import PaysafePaymentsSDK
```

## Setup
After Paysafe iOS package is integrated into your project, setup PaysafeSDK on application start.
```swift
import PaysafeCardPayments
 
// Custom theme example
let theme = PSTheme(   
    backgroundColor: UIColor(red: 44/255, green: 30/255, blue: 70/255, alpha: 1.0),   
    borderColor: UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1.0),   
    focusedBorderColor: UIColor(red: 133/255, green: 81/255, blue: 161/255, alpha: 1.0),    
    textInputColor: UIColor(red: 214/255, green: 195/255, blue: 229/255, alpha: 1.0),   
    placeholderColor: UIColor(red: 111/255, green: 77/255, blue: 155/255, alpha: 1.0),   
    hintColor: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
)
 
PaysafeSDK.shared.setup(   
    apiKey: apiKey,   
    environment: .test,
    theme: theme)
{ result in
    switch result {
    case .success:
        print("[Paysafe SDK] initialized successfully")
    case let .failure(error):
        print("[Paysafe SDK] initialize failure \(error.displayMessage)")
    }
}
```                                

The setup function creates and initializes the Paysafe iOS SDK. Pass the following parameters during its initialization from the application:

### API Key
The Base64-encoded version of the single-use token API key is used to authenticate with the Payments API. For more information about obtaining your API Keys, see Before you begin.

Note that this key can only be used to generate single-use tokens and has no other API access rights (such as for taking payments). Consequently, it can be exposed publicly in the customer's browser.

### Environment
The environment string is used to select the environment for tokenization. The accepted environments are PROD (Paysafe Production environment) and TEST (Paysafe Merchant Test or Sandbox environment).

Do not use real card numbers or other payment instrument details in the Merchant Test environment. Test/ Sandbox is not compliant with Payment Card Industry Data Security Standards (PCI-DSS) and does not protect cardholder/ payee information.

### Theme
The PSTheme class in the Paysafe SDK allows for a consistent look and feel across all card payment fields (card number, holder name, CVV, expiry date).

The PaysafeSDK allows theme configuration through the theme parameter. If this parameter is not added then the sdk will be initialised using the default theme.

This global theme will be used by all card components until overridden individually.
- **backgroundColor**: Card component background color
- **unfocusedBorderColor**: Card component border color in unfocused state
- **focusedBorderColor**: Card component border color in focused/selected state
- **borderCornerRadius**: Card component border corner radius
- **errorColor**: Card component border and top placeholder color for invalid/error state
- **textInputColor**: Card component text input color
- **placeholderColor**: Card component top & centered placeholder color
- **hintColor**: Card component hint/mask color
- **textInputFont**: Card component text input font
- **placeholderFont**: Card component top & centered placeholder font
- **hintFont**: Card component hint/mask font

## Callback Error Object Signature
| Parameter | Required | Type | Description |
|-----------|-----------|-----------|-----------|
| code     | true    | String    | Error Code |
| displayMessage     | true    | String    | Error message for display to customers. |
| detailedMessage     | true    | String    | Detailed description of the error (this information should not be displayed to customers). |
| correlationId     | true    | String    | Unique error ID to be provided to Paysafe Support during investigation |

## Card Payments
Collecting card payments in your iPhone app involves creating an object to collect card information, tokenizing card and payment details, and submitting the payment to Paysafe for processing.

More details related to card payments integration can be referenced at our [Developer Guide](https://developer.paysafe.com/en/api-docs/mobile-sdks-payments-api/paysafe-ios-sdk/card-payments/overview/)

## Apple Pay
Paysafe iOS SDK allows you to take payments via your iPhone apps using mobile-based payment methods, such as Apple Pay, that rely on card payments made through the Paysafe Payments API.

More details related to Apple Pay payments integration can be referenced at our [Developer Guide](https://developer.paysafe.com/en/api-docs/mobile-sdks-payments-api/paysafe-ios-sdk/apple-pay-integration/overview/)


## Venmo
Paysafe iPhone SDK allows you to take authenticated payments through Venmo iPhone App and submitting the payment to Paysafe for Processing

More details related to Venmo payments integration can be referenced at our [Developer Guide](https://developer.paysafe.com/en/api-docs/mobile-sdks-payments-api/paysafe-ios-sdk/venmo-integration-ios/) 

## Examples
Paysafe iOS SDK include standalone [Examples](https://github.com/paysafegroup/paysafe_sdk_ios_payments_api/tree/main/Example/LotteryTicket) module for testing all supported Payment Methods (Cards, Apple Pay & Venmo)