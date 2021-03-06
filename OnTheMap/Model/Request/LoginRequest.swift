//
//  Login.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    
    let udacity: UserDataRequest?
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}
