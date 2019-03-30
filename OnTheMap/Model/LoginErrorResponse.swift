//
//  LoginErrorResponse.swift
//  OnTheMap
//
//  Created by Sabrina on 3/30/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import Foundation

struct LoginErrorResponse: Codable {
    let status: Int
    let parameter: String
    let error: String
}

extension LoginErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
