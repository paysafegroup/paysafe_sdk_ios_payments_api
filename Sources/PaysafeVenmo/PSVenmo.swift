//
//  PSVenmo.swift
//  
//
//  Created by Eduardo Oliveros on 5/28/24.
//

import Combine
#if canImport(PaysafeCommon)
import PaysafeCommon
#endif
#if canImport(BraintreeCore)
import BraintreeVenmo
import BraintreeCore
#else
import Braintree
#endif


/// PSVenmo
public class PSVenmo {
    private let initiateVenmoFlowSubject = PassthroughSubject<PSVenmoBraintreeResult, PSError>()
    var venmoClient : BTVenmoClient?
    var apiClient : BTAPIClient?
    
    public init() {
        // Empty init, because we want to configure PSVenmo clients at a later stage.
    }
    
    /// - Parameters:
    ///   - clientId: Client id
    public func configureClient(clientId: String) {
        guard let newApiClient = BTAPIClient(authorization: clientId) else {
            return
        }
        apiClient = newApiClient
        venmoClient = BTVenmoClient(apiClient: newApiClient)
    }
    
    /// Method used to initiate the Venmo flow based on render type.
    ///
    /// - Parameters:
    ///   - orderId: Venmo order id
    public func initiateVenmoFlow(
        profileId: String,
        amount: Int
    ) -> AnyPublisher<PSVenmoBraintreeResult, PSError> {
        guard venmoClient?.isVenmoAppInstalled() ?? false else {
            venmoClient?.openVenmoAppPageInAppStore()
            initiateVenmoFlowSubject.send(completion: .failure(PSError.venmoAppNotFound()))
            return initiateVenmoFlowSubject.eraseToAnyPublisher()
        }

        return tokenizeVenmoAccount(profileId: profileId, amount: amount)
    }
    
    func tokenizeVenmoAccount(profileId: String, amount: Int, request: BTVenmoRequest = BTVenmoRequest(paymentMethodUsage: .multiUse)) -> AnyPublisher<PSVenmoBraintreeResult, PSError> {
        request.profileID = profileId
        request.totalAmount = String(amount)
        request.collectCustomerBillingAddress = true
        request.collectCustomerShippingAddress = true
        
        venmoClient?.tokenize(request) { [weak self] (venmoAccount, error) in
            
            if error != nil {
                self?.initiateVenmoFlowSubject.send(.cancel)
                return
            }
            guard let venmoAccount = venmoAccount else {
                self?.initiateVenmoFlowSubject.send(.failed)
                return
            }
            
            let account = VenmoAccount(email: venmoAccount.email, externalID: venmoAccount.externalID,firstName: venmoAccount.firstName, lastName: venmoAccount.lastName, phoneNumber: venmoAccount.phoneNumber, username: venmoAccount.username, nonce: venmoAccount.nonce, type: venmoAccount.type, isDefault: venmoAccount.isDefault)
            self?.initiateVenmoFlowSubject.send(.success(venmoAccount: account))
        }
        
        return initiateVenmoFlowSubject.eraseToAnyPublisher()
    }
}
