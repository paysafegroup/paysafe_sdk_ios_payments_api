//
//  PaysafeSDK.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

/// PaysafeSDK
public class PaysafeSDK {
    /// Paysafe API client
    var psAPIClient: PSAPIClient?
    /// Paysafe theme
    var psTheme = PSTheme()
    /// Correlation id
    let correlationId = UUID().uuidString.lowercased()
    /// Shared singleton PaysafeSDK.
    public static let shared = PaysafeSDK()

    /// Initializes the PaysafeSDK.
    ///
    /// - Parameters:
    ///   - apiKey: Paysafe API key
    ///   - environment: Paysafe environment
    ///   - theme: Paysafe theme
    ///   - completion: PSSDKSetupBlock
    public func setup(
        apiKey: String,
        environment: PaysafeEnvironment,
        theme: PSTheme = PSTheme(),
        completion: @escaping PSSDKSetupBlock
    ) {
        guard isValidAPIKey(apiKey) else {
            !performsUnitTests() ? assertionFailure(.invalidSDKAPIKeyMessage) : nil
            return completion(.failure(.coreInvalidAPIKey(correlationId)))
        }
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
    private func isValidAPIKey(_ apiKey: String) -> Bool {
        !apiKey.isEmpty
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
