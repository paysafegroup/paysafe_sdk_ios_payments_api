//
//  PSErrorTests.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

@testable import PaysafeCommon
import XCTest

final class PSErrorTests: XCTestCase {
    func test_customGenericAPIError() {
        // Give
        let error = PSError.genericAPIError(
            "correlationId",
            message: "Custom generic api error.",
            code: 1000
        )
        let expectedCode = 1000

        // Then
        XCTAssertEqual(error.errorCode, .genericAPIError)
        XCTAssertEqual(error.errorCode.type, .apiError)
        XCTAssertEqual(error.errorCode.type.rawValue, "APIError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Custom generic api error.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_genericAPIError() {
        // Given
        let error = PSError.genericAPIError("correlationId")
        let expectedCode = 9014

        // Then
        XCTAssertEqual(error.errorCode, .genericAPIError)
        XCTAssertEqual(error.errorCode.type, .apiError)
        XCTAssertEqual(error.errorCode.type.rawValue, "APIError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Unhandled error occurred.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_invalidResponse() {
        // Given
        let error = PSError.invalidResponse("correlationId")
        let expectedCode = 9002

        // Then
        XCTAssertEqual(error.errorCode, .invalidResponse)
        XCTAssertEqual(error.errorCode.type, .apiError)
        XCTAssertEqual(error.errorCode.type.rawValue, "APIError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Error communicating with server.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_invalidURL() {
        // Given
        let error = PSError.invalidURL("correlationId")
        let expectedCode = 9168

        // Then
        XCTAssertEqual(error.errorCode, .invalidURL)
        XCTAssertEqual(error.errorCode.type, .apiError)
        XCTAssertEqual(error.errorCode.type.rawValue, "APIError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Error communicating with server.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_encodingError() {
        // Given
        let error = PSError.encodingError("correlationId")
        let expectedCode = 9205

        // Then
        XCTAssertEqual(error.errorCode, .encodingError)
        XCTAssertEqual(error.errorCode.type, .apiError)
        XCTAssertEqual(error.errorCode.type.rawValue, "APIError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Encoding error.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_timeoutError() {
        // Given
        let error = PSError.timeoutError("correlationId")
        let expectedCode = 9204

        // Then
        XCTAssertEqual(error.errorCode, .timeoutError)
        XCTAssertEqual(error.errorCode.type, .apiError)
        XCTAssertEqual(error.errorCode.type.rawValue, "APIError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Timeout error.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_noConnectionToServer() {
        // Given
        let error = PSError.noConnectionToServer("correlationId")
        let expectedCode = 9001

        // Then
        XCTAssertEqual(error.errorCode, .noConnectionToServer)
        XCTAssertEqual(error.errorCode.type, .apiError)
        XCTAssertEqual(error.errorCode.type.rawValue, "APIError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "No connection to server.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_coreInvalidAPIKey() {
        // Given
        let error = PSError.coreInvalidAPIKey("correlationId")
        let expectedCode = 9167

        // Then
        XCTAssertEqual(error.errorCode, .coreInvalidAPIKey)
        XCTAssertEqual(error.errorCode.type, .coreError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CoreError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "The API key should not be empty.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_coreUnavailableEnvironment() {
        // Given
        let error = PSError.coreUnavailableEnvironment("correlationId")
        let expectedCode = 9203

        // Then
        XCTAssertEqual(error.errorCode, .coreUnavailableEnvironment)
        XCTAssertEqual(error.errorCode.type, .coreError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CoreError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "The PROD environment cannot be used in a simulator, emulator, rooted or jailbroken devices.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_coreSDKInitializeError() {
        // Given
        let error = PSError.coreSDKInitializeError("correlationId")
        let expectedCode = 9202

        // Then
        XCTAssertEqual(error.errorCode, .coreSDKInitializeError)
        XCTAssertEqual(error.errorCode.type, .coreError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CoreError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Application context not initialized!")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_coreMerchantAccountConfigurationError() {
        // Given
        let error = PSError.coreMerchantAccountConfigurationError("correlationId")
        let expectedCode = 9073

        // Then
        XCTAssertEqual(error.errorCode, .coreMerchantAccountConfigurationError)
        XCTAssertEqual(error.errorCode.type, .coreError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CoreError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Account not configured correctly.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_coreInvalidCurrencyCode() {
        // Given
        let error = PSError.coreInvalidCurrencyCode("correlationId")
        let expectedCode = 9055

        // Then
        XCTAssertEqual(error.errorCode, .coreInvalidCurrencyCode)
        XCTAssertEqual(error.errorCode.type, .coreError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CoreError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Invalid currency parameter.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_corePaymentHandleCreationFailed() {
        // Given
        let error = PSError.corePaymentHandleCreationFailed(
            "correlationId",
            message: "Status of the payment handle is FAILED."
        )
        let expectedCode = 9131

        // Then
        XCTAssertEqual(error.errorCode, .corePaymentHandleCreationFailed)
        XCTAssertEqual(error.errorCode.type, .coreError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CoreError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Status of the payment handle is FAILED.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_coreInvalidAccountId() {
        // Given
        let error = PSError.coreInvalidAccountId(
            "correlationId",
            message: "Invalid account id for selected payment method."
        )
        let expectedCode = 9061

        // Then
        XCTAssertEqual(error.errorCode, .coreInvalidAccountId)
        XCTAssertEqual(error.errorCode.type, .coreError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CoreError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Invalid account id for selected payment method.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_coreFailedToFetchAvailablePayments() {
        // Given
        let error = PSError.coreFailedToFetchAvailablePayments("correlationId")
        let expectedCode = 9084

        // Then
        XCTAssertEqual(error.errorCode, .coreFailedToFetchAvailablePayments)
        XCTAssertEqual(error.errorCode.type, .coreError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CoreError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Failed to load available payment methods.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_coreThreeDSAuthenticationRejected() {
        // Given
        let error = PSError.coreThreeDSAuthenticationRejected("correlationId")
        let expectedCode = 9040

        // Then
        XCTAssertEqual(error.errorCode, .coreThreeDSAuthenticationRejected)
        XCTAssertEqual(error.errorCode.type, .coreError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CoreError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Authentication result is not accepted for the provided account.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_coreTokenizationAlreadyInProgress() {
        // Given
        let error = PSError.coreTokenizationAlreadyInProgress("correlationId")
        let expectedCode = 9136

        // Then
        XCTAssertEqual(error.errorCode, .coreTokenizationAlreadyInProgress)
        XCTAssertEqual(error.errorCode.type, .coreError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CoreError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Tokenization is already in progress.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_threeDSFailedValidation() {
        // Given
        let error = PSError.threeDSFailedValidation("correlationId")
        let expectedCode = 9201

        // Then
        XCTAssertEqual(error.errorCode, .threeDSFailedValidation)
        XCTAssertEqual(error.errorCode.type, .threeDSError)
        XCTAssertEqual(error.errorCode.type.rawValue, "3DSError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "JWT is not validated.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_threeDSUserCancelled() {
        // Given
        let error = PSError.threeDSUserCancelled("correlationId")
        let expectedCode = 9200

        // Then
        XCTAssertEqual(error.errorCode, .threeDSUserCancelled)
        XCTAssertEqual(error.errorCode.type, .threeDSError)
        XCTAssertEqual(error.errorCode.type.rawValue, "3DSError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "User cancelled 3DS challenge.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_threeDSTimeout() {
        // Given
        let error = PSError.threeDSTimeout("correlationId")
        let expectedCode = 9199

        // Then
        XCTAssertEqual(error.errorCode, .threeDSTimeout)
        XCTAssertEqual(error.errorCode.type, .threeDSError)
        XCTAssertEqual(error.errorCode.type.rawValue, "3DSError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "3DS challenge timeout.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_threeDSSessionFailure() {
        // Given
        let error = PSError.threeDSSessionFailure(
            "correlationId",
            message: "Error message."
        )
        let expectedCode = 9198

        // Then
        XCTAssertEqual(error.errorCode, .threeDSSessionFailure)
        XCTAssertEqual(error.errorCode.type, .threeDSError)
        XCTAssertEqual(error.errorCode.type.rawValue, "3DSError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Error message.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_threeDSChallengePayloadError() {
        // Given
        let error = PSError.threeDSChallengePayloadError("correlationId")
        let expectedCode = 9197

        // Then
        XCTAssertEqual(error.errorCode, .threeDSChallengePayloadError)
        XCTAssertEqual(error.errorCode.type, .threeDSError)
        XCTAssertEqual(error.errorCode.type.rawValue, "3DSError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Unable to process challenge payload.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_applePayNotSupported() {
        // Given
        let error = PSError.applePayNotSupported("correlationId")
        let expectedCode = 9086

        // Then
        XCTAssertEqual(error.errorCode, .applePayNotSupported)
        XCTAssertEqual(error.errorCode.type, .applePayError)
        XCTAssertEqual(error.errorCode.type.rawValue, "ApplePayError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "The device does not support the payment methods, the user has no active card in the wallet, or the merchant domain is not validated with Apple.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_applePayUserCancelled() {
        // Given
        let error = PSError.applePayUserCancelled("correlationId")
        let expectedCode = 9042
        
        // Then
        XCTAssertEqual(error.errorCode, .applePayUserCancelled)
        XCTAssertEqual(error.errorCode.type, .applePayError)
        XCTAssertEqual(error.errorCode.type.rawValue, "ApplePayError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "User aborted authentication.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }
    
    func test_venmoFailedAuthorization() {
        // Given
        let error = PSError.venmoFailedAuthorization("correlationId")
        let expectedCode = 9291

        // Then
        XCTAssertEqual(error.errorCode, .venmoFailedAuthorization)
        XCTAssertEqual(error.errorCode.type, .venmoError)
        XCTAssertEqual(error.errorCode.type.rawValue, "VenmoError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Venmo failed authorization.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }
    
    func test_coreAPIInvalidCardDetails() {
        // Given
        let correlationId = "correlationId"
        let error = PSError.coreAPIInvalidCardDetails(correlationId)
        let expectedCode = 9003

        // Then
        XCTAssertEqual(error.errorCode, .coreAPIInvalidCardDetails)
        XCTAssertEqual(error.errorCode.type, .threeDSError)
        XCTAssertEqual(error.errorCode.type.rawValue, "3DSError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "You submitted an invalid card number or brand or combination of card number and brand with your request.")
        XCTAssertEqual(error.correlationId, correlationId)
    }
    
    func test_venmoAppNotFound() {
        // Given
        let error = PSError.venmoAppNotFound()
        let expectedCode = 9197

        // Then
        XCTAssertEqual(error.errorCode, .venmoAppIsNotInstalled)
        XCTAssertEqual(error.errorCode.type, .venmoError)
        XCTAssertEqual(error.errorCode.type.rawValue, "VenmoError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Venmo App Doesn't exist.")
        XCTAssertEqual(error.correlationId, "N/A")
    }

    func test_venmoUserCancelled() {
        // Given
        let error = PSError.venmoUserCancelled("correlationId")
        let expectedCode = 9195

        // Then
        XCTAssertEqual(error.errorCode, .venmoUserCancelled)
        XCTAssertEqual(error.errorCode.type, .venmoError)
        XCTAssertEqual(error.errorCode.type.rawValue, "VenmoError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "User cancelled Venmo flow.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_invalidCardFields() {
        // Given
        let error = PSError.invalidCardFields(
            "correlationId",
            message: "Invalid fields."
        )
        let expectedCode = 9003

        // Then
        XCTAssertEqual(error.errorCode, .invalidCardFields)
        XCTAssertEqual(error.errorCode.type, .cardFormError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CardFormError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Invalid fields.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_invalidAccountIdFormat() {
        // Given
        let error = PSError.invalidAccountIdFormat("correlationId")
        let expectedCode = 9101

        // Then
        XCTAssertEqual(error.errorCode, .invalidAccountIdFormat)
        XCTAssertEqual(error.errorCode.type, .cardFormError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CardFormError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Invalid accountId parameter.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_noAvailablePayments() {
        // Given
        let error = PSError.noAvailablePayments("correlationId")
        let expectedCode = 9085

        // Then
        XCTAssertEqual(error.errorCode, .noAvailablePayments)
        XCTAssertEqual(error.errorCode.type, .cardFormError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CardFormError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "There are no available payment methods for this API key.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_unsuportedCardBrand() {
        // Given
        let error = PSError.unsuportedCardBrand("correlationId")
        let expectedCode = 9125

        // Then
        XCTAssertEqual(error.errorCode, .unsuportedCardBrand)
        XCTAssertEqual(error.errorCode.type, .cardFormError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CardFormError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Unsupported card brand used.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_invalidAmount() {
        // Given
        let error = PSError.invalidAmount("correlationId")
        let expectedCode = 9054

        // Then
        XCTAssertEqual(error.errorCode, .invalidAmount)
        XCTAssertEqual(error.errorCode.type, .cardFormError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CardFormError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Amount should be a number greater than 0 no longer than 11 characters.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_invalidDynamicDescriptor() {
        // Given
        let error = PSError.invalidDynamicDescriptor("correlationId")
        let expectedCode = 9098

        // Then
        XCTAssertEqual(error.errorCode, .invalidDynamicDescriptor)
        XCTAssertEqual(error.errorCode.type, .cardFormError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CardFormError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Invalid parameter in merchantDescriptor.dynamicDescriptor.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_invalidPhone() {
        // Given
        let error = PSError.invalidPhone("correlationId")
        let expectedCode = 9099

        // Then
        XCTAssertEqual(error.errorCode, .invalidPhone)
        XCTAssertEqual(error.errorCode.type, .cardFormError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CardFormError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Invalid parameter in merchantDescriptor.phone.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_invalidFirstName() {
        // Given
        let error = PSError.invalidFirstName("correlationId")
        let expectedCode = 9112

        // Then
        XCTAssertEqual(error.errorCode, .invalidFirstName)
        XCTAssertEqual(error.errorCode.type, .cardFormError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CardFormError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Profile firstName should be valid.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_invalidLastName() {
        // Given
        let error = PSError.invalidLastName("correlationId")
        let expectedCode = 9113

        // Then
        XCTAssertEqual(error.errorCode, .invalidLastName)
        XCTAssertEqual(error.errorCode.type, .cardFormError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CardFormError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Profile lastName should be valid.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_invalidEmail() {
        // Given
        let error = PSError.invalidEmail("correlationId")
        let expectedCode = 9119

        // Then
        XCTAssertEqual(error.errorCode, .invalidEmail)
        XCTAssertEqual(error.errorCode.type, .cardFormError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CardFormError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Profile email should be valid.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_invalidAPIKeyFormat() {
        // Given
        let error = PSError.coreInvalidAPIKeyFormat("correlationId")
        let expectedCode = 9013

        // Then
        XCTAssertEqual(error.errorCode, .coreInvalidAPIKeyFormat)
        XCTAssertEqual(error.errorCode.type, .coreError)
        XCTAssertEqual(error.errorCode.type.rawValue, "CoreError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Invalid API key.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_threeDSInvalidResponse() {
        // Given
        let error = PSError.threeDSInvalidResponse("correlationId")
        let expectedCode = 9002

        // Then
        XCTAssertEqual(error.errorCode, .threeDSInvalidResponse)
        XCTAssertEqual(error.errorCode.type, .threeDSError)
        XCTAssertEqual(error.errorCode.type.rawValue, "3DSError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Error communicating with server.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_threeDSInvalidURL() {
        // Given
        let error = PSError.threeDSInvalidURL("correlationId")
        let expectedCode = 9168

        // Then
        XCTAssertEqual(error.errorCode, .threeDSInvalidURL)
        XCTAssertEqual(error.errorCode.type, .threeDSError)
        XCTAssertEqual(error.errorCode.type.rawValue, "3DSError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Error communicating with server.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }

    func test_threeDSEncodingError() {
        // Given
        let error = PSError.threeDSEncodingError("correlationId")
        let expectedCode = 9205

        // Then
        XCTAssertEqual(error.errorCode, .threeDSEncodingError)
        XCTAssertEqual(error.errorCode.type, .threeDSError)
        XCTAssertEqual(error.errorCode.type.rawValue, "3DSError")
        XCTAssertEqual(error.code, expectedCode)
        XCTAssertEqual(error.displayMessage, "There was an error (\(expectedCode)), please contact our support.")
        XCTAssertEqual(error.detailedMessage, "Encoding error.")
        XCTAssertEqual(error.correlationId, "correlationId")
    }
}

