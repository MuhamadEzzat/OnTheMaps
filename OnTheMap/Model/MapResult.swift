//
//  MapResult.swift
//  OnTheMap
//
//  Created by Mohamed Ezzat on 17/01/2022.
//

import Foundation

struct MapResult:Codable{
    
    var objectId: String
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case objectId
        case createdAt
    }
}
