//
//  PSTextFieldValidator.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import UIKit

protocol PSTextFieldValidator {
    func validate(characters: String) -> Bool
    func validate(field: String) -> Bool
}
