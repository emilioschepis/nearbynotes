//
//  Profile.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 10/12/23.
//

import Foundation

struct Profile: Identifiable, Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
    }
    
    let id: String
    let createdAt: Date
}
