//
//  CardinalSessionMock.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import CardinalMobile

class CardinalSessionMock: CardinalSession {
    override func configure(_ sessionConfig: CardinalSessionConfiguration) {}

    override func setup(
        jwtString: String,
        completed didCompleteHandler: @escaping CardinalSessionSetupDidCompleteHandler,
        validated didValidateHandler: @escaping CardinalSessionSetupDidValidateHandler
    ) {
        didCompleteHandler("consumerSessionId")
    }

    override func continueWith(
        transactionId: String,
        payload: String,
        validationDelegate: CardinalValidationDelegate
    ) {}
}
