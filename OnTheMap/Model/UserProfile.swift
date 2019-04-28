//
//  UserProfile.swift
//  OnTheMap
//
//  Created by Sabrina on 4/24/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
}
