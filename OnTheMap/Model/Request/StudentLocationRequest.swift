//
//  StudentLocationRequest.swift
//  OnTheMap
//
//  Created by Mohamed Ezzat on 15/01/2022.
//

import Foundation

struct StudentLocationRequest: Codable {
    
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    
    
    enum CodingKeys: String, CodingKey {
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaURL
        case latitude
        case longitude
    }
}

