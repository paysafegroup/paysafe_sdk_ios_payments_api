//
//  PSApplePay.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
import PassKit
#if canImport(PaysafeCommon)
import PaysafeCommon
#endif

/// PSApplePay
public class PSApplePay: NSObject {
    /// PKPaymentRequest
    let paymentRequest: PKPaymentRequest
    /// PKPaymentAuthorizationController
    var authorizationController: PKPaymentAuthorizationController?
    /// Initiate Apple Pay flow subject
    let initiateApplePayFlowSubject = PassthroughSubject<Result<InitializeApplePayResponse, PSError>, Never>()
    /// Apple Pay state
    private var applePayState: ApplePayState = .pending

    /// ApplePayState
    enum ApplePayState {
        /// Pending Apple Pay state
        case pending
        /// Completed Apple Pay state
        case completed
    }

    /// - Parameters:
    ///   - merchantIdentifier: Merchant identifier
    ///   - countryCode: Country code
    ///   - supportedNetworks: Supported payment networks
    public init(
        merchantIdentifier: String,
        countryCode: String,
        supportedNetworks: Set<SupportedNetwork>
    ) {
        paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = merchantIdentifier
        paymentRequest.supportedNetworks = supportedNetworks.map(\.network)
        paymentRequest.countryCode = countryCode.uppercased()
        super.init()
        configureMerchantCapabilities(supportedNetworks)
    }

    /// Method used to initiate the Apple Pay flow.
    ///
    /// - Parameters:
    ///   - currencyCode: Currency code
    ///   - amount: Payment amount
    ///   - psApplePay: PSApplePay payment item
    public func initiateApplePayFlow(
        currencyCode: String,
        amount: Double,
        psApplePay: PSApplePayItem
    ) -> AnyPublisher<Result<InitializeApplePayResponse, PSError>, Never> {
        applePayState = .pending
        paymentRequest.currencyCode = currencyCode.uppercased()
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(
                label: psApplePay.label,
                amount: NSDecimalNumber(value: amount)
            )
        ]
        if psApplePay.requestBillingAddress {
            paymentRequest.requiredBillingContactFields = [
                .name,
                .emailAddress,
                .postalAddress,
                .phoneNumber
            ]
        }
        authorizationController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        authorizationController?.delegate = self
        authorizationController?.present()
        return initiateApplePayFlowSubject.eraseToAnyPublisher()
    }
}

public extension PSApplePay {
    /// Construct name based on firstName and lastName. At least one value is required to exist based on the requiredBillingContactFields setup.
    ///
    /// - Parameters:
    ///   - firstName: User's first name
    ///   - lastName: User's last name
    func constructName(
        using firstName: String?,
        and lastName: String?
    ) -> String {
        if let firstName = firstName, let lastName = lastName {
            return "\(firstName) \(lastName)"
        } else if let firstName = firstName {
            return firstName
        } else if let lastName = lastName {
            return lastName
        } else {
            fatalError("Both firstName and lastName cannot be nil")
        }
    }

    /// Map PKConctact to BillingContact
    ///
    /// - Parameters:
    ///   - pkContact: PKContact
    func mapPKContactToBillingContact(_ pkContact: PKContact?) -> BillingContact? {
        guard let pkContact else { return nil }
        let firstName = pkContact.name?.givenName?.nilIfEmpty
        let lastName = pkContact.name?.familyName?.nilIfEmpty
        let email = pkContact.emailAddress?.nilIfEmpty
        let addressLine = pkContact.postalAddress?.street.split(separator: "\n").map(String.init) ?? []
        let country = pkContact.postalAddress?.country.nilIfEmpty
        let countryCode = pkContact.postalAddress?.isoCountryCode.nilIfEmpty
        let postalCode = pkContact.postalAddress?.postalCode.nilIfEmpty
        let locality = pkContact.postalAddress?.city.nilIfEmpty
        let administrativeArea = pkContact.postalAddress?.state.nilIfEmpty
        let phone = pkContact.phoneNumber?.stringValue.nilIfEmpty

        return BillingContact(
            addressLines: addressLine,
            countryCode: countryCode,
            email: email,
            locality: locality,
            name: constructName(
                using: firstName,
                and: lastName
            ),
            phone: phone,
            country: country,
            postalCode: postalCode,
            administrativeArea: administrativeArea
        )
    }
}

// MARK: - Private
private extension PSApplePay {
    /// Configures merchant capabilities based on supported networks.
    ///
    /// - Parameters:
    ///   - networks: Supported payment networks
    func configureMerchantCapabilities(_ supportedNetworks: Set<SupportedNetwork>) {
        paymentRequest.merchantCapabilities = supportedNetworks.reduce(into: []) { result, network in
            result.formUnion(.threeDSecure)
            switch network.capability {
            case .credit:
                result.formUnion(.credit)
            case .debit:
                result.formUnion(.debit)
            case .both:
                result.formUnion([.credit, .debit])
            }
        }
    }

    /// Finalize the Apple Pay payment.
    ///
    /// - Parameters:
    ///   - payment: PKPayment
    ///   - completion: PSApplePayFinalizeBlock
    func finalizePayment(
        using payment: PKPayment,
        and completion: PSApplePayFinalizeBlock?
    ) {
        applePayState = .completed
        let billingContact = mapPKContactToBillingContact(payment.billingContact)
        let initializeApplePayResponse = InitializeApplePayResponse(
            applePayPaymentToken: payment.toApplePayPaymentToken(using: billingContact),
            completion: completion
        )
        initiateApplePayFlowSubject.send(.success(initializeApplePayResponse))
    }
}

// MARK: - PKPaymentAuthorizationControllerDelegate
extension PSApplePay: PKPaymentAuthorizationControllerDelegate {
    public func paymentAuthorizationControllerDidFinish(
        _ controller: PKPaymentAuthorizationController
    ) {
        switch applePayState {
        case .pending:
            controller.dismiss { [weak self] in
                guard let self else { return }
                authorizationController = nil
                initiateApplePayFlowSubject.send(.failure(.applePayUserCancelled()))
            }
        case .completed:
            controller.dismiss { [weak self] in
                guard let self else { return }
                authorizationController = nil
            }
        }
    }

    public func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        finalizePayment(
            using: payment
        ) { status, error in
            completion(
                PKPaymentAuthorizationResult(
                    status: status,
                    errors: [error].compactMap { $0 }
                )
            )
        }
    }
}
