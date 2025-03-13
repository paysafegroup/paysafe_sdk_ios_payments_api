//
//  File.swift
//  
//
//  Created by Miroslav Ganchev on 22.07.24.
//

import Combine
#if canImport(PaysafeCommon)
import PaysafeCommon
#endif
#if canImport(Paysafe3DS)
import Paysafe3DS
#endif

extension PSAPIClient {
    /// Handle card payment response.
    ///
    /// - Parameters:
    ///   - paymentResponse: Payment response
    func handleCardPaymentResponse(
        using paymentHandle: PaymentHandle,
        process: Bool?,
        paysafe3DS: Paysafe3DS
    ) -> AnyPublisher<String, PSError> {
        switch paymentHandle.status {
        case .payable, .completed:
            return Just(paymentHandle.paymentHandleToken).setFailureType(to: PSError.self).eraseToAnyPublisher()
        case .initiated where paymentHandle.action == "REDIRECT",
             .processing where paymentHandle.action == "REDIRECT":
            return initiate3DSFlow(using: paymentHandle,
                                   process: process,
                                   paysafe3DS: paysafe3DS)
        case .expired, .failed, .processing, .initiated:
            let error = PSError.corePaymentHandleCreationFailed(
                PaysafeSDK.shared.correlationId,
                message: "Status of the payment handle is \(paymentHandle.status)"
            )
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    private func initiate3DSFlow(
        using paymentHandle: PaymentHandle,
        process: Bool?,
        paysafe3DS: Paysafe3DS
    ) -> AnyPublisher<String, PSError> {
        guard let cardBin = paymentHandle.card?.networkToken?.bin ?? paymentHandle.card?.cardBin else {
            return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId))
                .eraseToAnyPublisher()
        }
        /// We prioritize the accountId received from the response. If the response comes with a nil value we use the
        /// accountId provided in the Tokenizable object.
        let availableAccountId = paymentHandle.accountId ?? accountId
        guard let availableAccountId else {
            return Fail(error: .coreInvalidAccountId(
                PaysafeSDK.shared.correlationId,
                message: "Invalid account id for \(PaymentType.card.rawValue)."
            ))
            .eraseToAnyPublisher()
        }

        let threeDSOptions = Paysafe3DSOptions(
            accountId: availableAccountId,
            bin: cardBin
        )
        return paysafe3DS.initiate3DSFlow(
            using: threeDSOptions,
            and: getSupportedUI(from: renderType)
        )
        .flatMap { [weak self] deviceFingerprintingId -> AnyPublisher<AuthenticationResponse, PSError> in
            guard let self,
                  let id = paymentHandle.id else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            let challengePayloadOptions = ChallengePayloadOptions(
                id: id,
                merchantRefNum: paymentHandle.merchantRefNum,
                process: process
            )
            return getChallengePayload(
                using: challengePayloadOptions,
                and: deviceFingerprintingId
            )
        }
        .flatMap { [weak self] authenticationResponse -> AnyPublisher<Void, PSError> in
            guard let self,
                  let id = paymentHandle.id else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            return handleAuthenticationResponse(
                using: authenticationResponse,
                and: id,
                paysafe3DS: paysafe3DS
            )
        }
        .flatMap { [weak self] _ -> AnyPublisher<String, PSError> in
            guard let self else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            return refreshPaymentToken(
                using: paymentHandle.paymentHandleToken
            )
        }
        .eraseToAnyPublisher()
    }

    /// Get challenge payload.
    ///
    /// - Parameters:
    ///   - options: ChallengePayloadOptions
    ///   - deviceFingerprintingId: Device fingerprinting id
    func getChallengePayload(
        using options: ChallengePayloadOptions,
        and deviceFingerprintingId: String
    ) -> AnyPublisher<AuthenticationResponse, PSError> {
        let authenticationRequest = AuthenticationRequest(
            deviceFingerprintingId: deviceFingerprintingId,
            merchantRefNum: options.merchantRefNum,
            process: options.process
        )
        let getChallengePayloadUrl = environment.baseURL + "/cardadapter/v1/paymenthandles/\(options.id)/authentications"
        return networkingService.request(
            url: getChallengePayloadUrl,
            httpMethod: .post,
            payload: authenticationRequest
        )
        .mapError { $0.toPSError(PaysafeSDK.shared.correlationId) }
        .eraseToAnyPublisher()
    }

    /// Handle authentication response.
    ///
    /// - Parameters:
    ///   - response: AuthenticationResponse
    ///   - paymentHandleId: Payment handle id
    func handleAuthenticationResponse(
        using response: AuthenticationResponse,
        and paymentHandleId: String,
        paysafe3DS: Paysafe3DS
    ) -> AnyPublisher<Void, PSError> {
        switch response.status {
        case .completed:
            return Just(()).setFailureType(to: PSError.self).eraseToAnyPublisher()
        case .pending:
            return handlePendingAuthenticationStatus(
                using: response.sdkChallengePayload,
                and: paymentHandleId,
                paysafe3DS: paysafe3DS
            )
        case .failed:
            let error = PSError.corePaymentHandleCreationFailed(
                PaysafeSDK.shared.correlationId,
                message: "Status of the payment handle is \(response.status)"
            )
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    /// Handle pending authentication status.
    ///
    /// - Parameters:
    ///   - challengePayload: Challenge payload
    ///   - paymentHandleId: Payment handle id
    func handlePendingAuthenticationStatus(
        using challengePayload: String?,
        and paymentHandleId: String,
        paysafe3DS: Paysafe3DS
    ) -> AnyPublisher<Void, PSError> {
        return paysafe3DS.startChallenge(
            using: challengePayload
        )
        .flatMap { [weak self] authenticationId -> AnyPublisher<FinalizeResponse, PSError> in
            guard let self else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            return finalizePaymentHandle(
                using: paymentHandleId,
                and: authenticationId
            )
        }
        .flatMap { [weak self] finalizeResponse -> AnyPublisher<Void, PSError> in
            guard let self else {
                return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
            }
            return handleFinalizeResponse(
                using: finalizeResponse
            )
        }
        .eraseToAnyPublisher()
    }

    /// Finalize payment handle.
    ///
    /// - Parameters:
    ///   - paymentHandleId: Payment handle id
    ///   - authenticationId: Authentication id
    func finalizePaymentHandle(
        using paymentHandleId: String,
        and authenticationId: String
    ) -> AnyPublisher<FinalizeResponse, PSError> {
        let finalizeUrl = environment.baseURL + "/cardadapter/v1/paymenthandles/\(paymentHandleId)/authentications/\(authenticationId)/finalize"
        return networkingService.request(
            url: finalizeUrl,
            httpMethod: .post,
            payload: EmptyRequest()
        )
        .mapError { $0.toPSError(PaysafeSDK.shared.correlationId) }
        .eraseToAnyPublisher()
    }

    /// Handle finalize response status.
    ///
    /// - Parameters:
    ///   - response: FinalizeResponse
    func handleFinalizeResponse(
        using response: FinalizeResponse
    ) -> AnyPublisher<Void, PSError> {
        switch response.status {
        case .completed:
            return Just(()).setFailureType(to: PSError.self).eraseToAnyPublisher()
        case .pending:
            return Fail(error: .genericAPIError(PaysafeSDK.shared.correlationId)).eraseToAnyPublisher()
        case .failed:
            let error = PSError.corePaymentHandleCreationFailed(
                PaysafeSDK.shared.correlationId,
                message: "Status of the payment handle is \(response.status)"
            )
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    /// Maps the render type chosen by the merchant and returns the ThreeDS supported ui.
    func getSupportedUI(from renderType: RenderType?) -> Paysafe3DS.SupportedUI? {
        guard let renderType else { return nil }
        switch renderType {
        case .native:
            return .native
        case .html:
            return .html
        case .both:
            return .both
        }
    }
}
