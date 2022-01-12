//
//  StudentsResults.swift
//  OnTheMap
//
//  Created by Mohamed Ezzat on 11/01/2022.
//

import Foundation

struct StudentsResults:Codable{
    var results: [Results]?
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
