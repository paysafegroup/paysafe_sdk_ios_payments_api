//
//  Paysafe3DSMock.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Combine
@testable import Paysafe3DS
#if canImport(PaysafeCommon)
import PaysafeCommon
#endif

public class Paysafe3DSMock: Paysafe3DS {
    var initiate3DSFlowWithSuccess: Bool = true
    var initiateChallengeWithSuccess: Bool = true
    var challengeAuthenticationId: String = "challengeAuthenticationId"

    public override func initiate3DSFlow(
        using options: Paysafe3DSOptions,
        and supportedUI: SupportedUI? = nil,
        completion: @escaping PaysafeInitiate3DSFlowCompletion
    ) {
        switch initiate3DSFlowWithSuccess {
        case true:
            return completion(.success(""))
        case false:
            return completion(.failure(.genericAPIError()))
        }
    }

    public override func initiate3DSFlow(
        using options: Paysafe3DSOptions,
        and supportedUI: SupportedUI? = nil
    ) -> AnyPublisher<String, PSError> {
        switch initiate3DSFlowWithSuccess {
        case true:
            return Just("").setFailureType(to: PSError.self).eraseToAnyPublisher()
        case false:
            return Fail(error: .genericAPIError()).eraseToAnyPublisher()
        }
    }

    public override func startChallenge(using payload: String?, completion: @escaping PaysafeStart3DSChallengeCompletion) {
        switch initiateChallengeWithSuccess {
        case true:
            completion(.success(challengeAuthenticationId))
        case false:
            completion(.failure(.genericAPIError()))
        }
    }

    public override func startChallenge(using payload: String?) -> AnyPublisher<String, PSError> {
        switch initiateChallengeWithSuccess {
        case true:
            return Just(challengeAuthenticationId).setFailureType(to: PSError.self).eraseToAnyPublisher()
        case false:
            return Fail(error: .genericAPIError()).eraseToAnyPublisher()
        }
    }
}

// MARK: - Convenience methods for setting stubs
extension Paysafe3DSMock {
    public func stub3DSSucceeds(challengeAuthenticationId: String) {
        self.challengeAuthenticationId = challengeAuthenticationId
        initiate3DSFlowWithSuccess = true
        initiateChallengeWithSuccess = true
    }

    public func stub3DSInitFails() {
        initiate3DSFlowWithSuccess = false
    }

    public func stub3DSChallengeFails() {
        initiate3DSFlowWithSuccess = false
        initiateChallengeWithSuccess = true
    }
}
