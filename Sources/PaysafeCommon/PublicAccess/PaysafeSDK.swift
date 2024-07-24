//
//  PaysafeSDK.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

/// Paysafe SDK setup block.
public typealias PSSDKSetupBlock = (Result<Bool, PSError>) -> Void
/// Paysafe tokenize block used in the `tokenize` method that contains a result with paymentHandleToken response as a String or an error as PSError.

/// PaysafeSDK
public class PaysafeSDK {
    /// Paysafe API client
    public var psAPIClient: PSAPIClient?
    /// Paysafe theme
    public var psTheme = PSTheme()
    /// Correlation id
    public let correlationId = UUID().uuidString.lowercased()
    /// Shared singleton PaysafeSDK.
    public static let shared = PaysafeSDK()

    public init(psAPIClient: PSAPIClient? = nil, psTheme: PSTheme = PSTheme()) {
        self.psAPIClient = psAPIClient
        self.psTheme = psTheme
    }

    /// Initializes the PaysafeSDK.
    ///
    /// - Parameters:
    ///   - apiKey: Paysafe API key
    ///   - environment: Paysafe environment
    ///   - paysafe3DS : Paysafe3DS
    ///   - theme: Paysafe theme
    ///   - completion: PSSDKSetupBlock
    public func setup(
        apiKey: String,
        environment: PaysafeEnvironment,
        theme: PSTheme = PSTheme(),
        completion: @escaping PSSDKSetupBlock
    ) {
        /// Validate the apiKey
        do {
            try validateApiKey(apiKey)
        } catch let error as PSError {
            return completion(.failure(error))
        } catch {
            completion(.failure(.genericAPIError(correlationId)))
        }
        /// Validate correct environment
        guard isEnvironmentAvailable(environment) else {
            !performsUnitTests() ? assertionFailure(.unavailableSDKEnvironment) : nil
            return completion(.failure(.coreUnavailableEnvironment(correlationId)))
        }
        psAPIClient = PSAPIClient(
            apiKey: apiKey,
            environment: environment
        )
        psTheme = theme
        completion(.success(true))
    }

    /// Returns the `PSAPIClient` if the setup is completed, nil otherwise.
    public func getPSAPIClient() -> PSAPIClient? {
        psAPIClient
    }

    /// Returns a uniquely generated merchant reference number.
    public func getMerchantReferenceNumber() -> String {
        UUID().uuidString
    }

    /// Determines if the Paysafe API key is valid.
    ///
    /// - Parameters:
    ///   - apiKey: Paysafe API key
    private func validateApiKey(_ apiKey: String) throws {
        guard !apiKey.isEmpty else {
            throw PSError.coreInvalidAPIKey(correlationId)
        }
        guard validateBase64EncodedString(apiKey) else {
            throw PSError.coreInvalidAPIKeyFormat(correlationId)
        }
    }

    /// Determines if the Paysafe API key has the valid decoded string format.
    /// The valid pattern should be: "username:password"
    ///
    /// - Parameters:
    ///   - base64String: Paysafe API key as base64 string
    private func validateBase64EncodedString(_ base64String: String) -> Bool {
        guard let decodedString = base64String.fromBase64() else {
            return false
        }
        /// Check if the pattern username:password can be found
        if let index = decodedString.firstIndex(of: ":") {
            /// We validate ":" is not only the first or last character
            return index != decodedString.startIndex && index != decodedString.index(before: decodedString.endIndex)
        }
        return false
    }

    /// Determines if the Paysafe Environment is available.
    /// Paysafe `production` environment is unavailable for simulator or jailbroken devices.
    ///
    /// - Parameters:
    ///   - environment: Paysafe environment
    private func isEnvironmentAvailable(_ environment: PaysafeEnvironment) -> Bool {
        switch environment {
        case .production:
            let isAvailable = !isSimulator() && !PSJailbreakChecker.isJailbroken()
            return isAvailable
        case .test:
            return true
        }
    }

    /// Determines if the device used is a simulator.
    private func isSimulator() -> Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }

    /// Determines if unit tests are being performed.
    private func performsUnitTests() -> Bool {
        NSClassFromString("XCTest") != nil
    }
}

// MARK: - Assertion failure messages
extension String {
    /// Uninitialized SDK assertion failure message.
    public static let uninitializedSDKMessage = "Initialize PaysafeSDK using the `setup` method."
    /// Initialize SDK with valid API key assertion failure message.
    public static let invalidSDKAPIKeyMessage = "Initialize PaysafeSDK with a valid API key."
    /// Unavailable environment assertion failure message.
    public static let unavailableSDKEnvironment = "Paysafe production environment is unavailable for simulator or jailbroken devices."
}
