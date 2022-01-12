//
//  UserDataRequest.swift
//  OnTheMap
//
//  Created by Mohamed Ezzat on 11/01/2022.
//

import Foundation

struct UserDataRequest: Codable {
    
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}
