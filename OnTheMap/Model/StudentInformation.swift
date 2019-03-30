//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Sabrina on 3/30/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
}
