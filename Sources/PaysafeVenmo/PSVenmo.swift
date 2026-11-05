//
//  PSVenmo.swift
//  
//
//  Created by Eduardo Oliveros on 5/28/24.
//

import Combine
import Foundation
#if canImport(PaysafeCommon)
import PaysafeCommon
#endif
#if canImport(BraintreeCore)
import BraintreeVenmo
import BraintreeCore
import BraintreeDataCollector
#else
import Braintree
#endif


/// Braintree Venmo client used by ``PSVenmoContext`` to run the app-switch payment flow.
public class PSVenmo {
    private let initiateVenmoFlowSubject = PassthroughSubject<PSVenmoBraintreeResult, PSError>()
    var venmoClient : BTVenmoClient?
    var apiClient : BTAPIClient?
    var dataCollector: BTDataCollector?

    /// Creates an unconfigured Venmo client. Call ``configureClient(clientToken:universalLink:)`` before starting a flow.
    public init() {
        // Empty init, because we want to configure PSVenmo clients at a later stage.
    }
    
    /// Configures the Braintree API and Venmo clients used for app switch.
    ///
    /// If `clientToken` is not a valid Braintree authorization string, the clients are left unset.
    ///
    /// - Parameters:
    ///   - clientToken: Braintree client token from the payment handle gateway response.
    ///   - universalLink: HTTPS URL Venmo uses to redirect back after authentication. Must be dedicated
    ///     to Braintree app-switch returns and registered as an associated domain for this app.
    public func configureClient(clientToken: String, universalLink: URL) {
        let newApiClient = BTAPIClient(authorization: clientToken)
        guard newApiClient.authorization.type != .invalidAuthorization else {
            return
        }
        apiClient = newApiClient
        venmoClient = BTVenmoClient(authorization: clientToken, universalLink: universalLink)
        dataCollector = BTDataCollector(authorization: clientToken)
    }
    
    /// Starts the Venmo authorization flow and publishes the Braintree result.
    ///
    /// Call ``configureClient(clientToken:universalLink:)`` first. The publisher emits success with a
    /// ``VenmoAccount``, cancel, or failed.
    ///
    /// - Parameters:
    ///   - profileId: Optional Venmo profile id for the merchant account.
    ///   - amount: Payment amount already converted to a major-unit string for Braintree.
    public func initiateVenmoFlow(
        profileId: String?,
        amount: String
    ) -> AnyPublisher<PSVenmoBraintreeResult, PSError> {
        tokenizeVenmoAccount(profileId: profileId, amount: amount)
    }
    
    func tokenizeVenmoAccount(profileId: String?, amount: String) -> AnyPublisher<PSVenmoBraintreeResult, PSError> {
        let request = BTVenmoRequest(
            paymentMethodUsage: .multiUse,
            profileID: profileId,
            collectCustomerBillingAddress: true,
            collectCustomerShippingAddress: true,
            totalAmount: amount
        )

        venmoClient?.tokenize(request) { [weak self] (venmoAccount, error) in
            self?.handleTokenizeResult(venmoAccount: venmoAccount, error: error)
        }
        
        return initiateVenmoFlowSubject.eraseToAnyPublisher()
    }

    func handleTokenizeResult(venmoAccount: BTVenmoAccountNonce?, error: Error?) {
        if error != nil {
            initiateVenmoFlowSubject.send(.cancel)
            return
        }
        guard let venmoAccount else {
            initiateVenmoFlowSubject.send(.failed)
            return
        }

        let account = VenmoAccount(
            email: venmoAccount.email,
            externalID: venmoAccount.externalID,
            firstName: venmoAccount.firstName,
            lastName: venmoAccount.lastName,
            phoneNumber: venmoAccount.phoneNumber,
            username: venmoAccount.username,
            nonce: venmoAccount.nonce,
            type: venmoAccount.type,
            isDefault: venmoAccount.isDefault
        )
        initiateVenmoFlowSubject.send(.success(venmoAccount: account))
    }

    /// Collects Braintree device data for fraud tools. Returns an empty string if collection is unavailable.
    func collectDeviceData(clientMetadataId: String?) -> AnyPublisher<String, Never> {
        Future { [weak self] promise in
            guard let dataCollector = self?.dataCollector else {
                promise(.success(""))
                return
            }
            dataCollector.collectDeviceDataOnSuccess(riskCorrelationID: clientMetadataId,  { deviceData, _ in
                promise(.success(deviceData ?? ""))
            })
        }
        .eraseToAnyPublisher()
    }
}
