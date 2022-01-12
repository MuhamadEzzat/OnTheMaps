//
//  File.swift
//  OnTheMap
//
//  Created by Mohamed Ezzat on 11/01/2022.
//

import Foundation

struct LogoutRequest: Codable {
    
    let sessionId: String?
    
    enum CodingKeys: String, CodingKey {
        case sessionId
    }
}
