//
//  Like.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 15/12/23.
//

import Foundation

struct Like: Codable, Equatable, Hashable {
    enum CodingKeys: String, CodingKey {
        case profileId = "profile_id"
        case createdAt = "created_at"
    }
    
    static let example = Like(profileId: "", createdAt: .now)
    
    let profileId: String
    let createdAt: Date
}
