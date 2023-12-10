//
//  Configuration.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 10/12/23.
//

import Foundation

struct Configuration: Identifiable, Codable {
    struct Metadata: Codable {
        enum CodingKeys: String, CodingKey {
            case findNearbyNotesDistance = "find_nearby_notes_distance"
            case findNearbyNotesLimit = "find_nearby_notes_limit"
        }
        
        let findNearbyNotesDistance: Double
        let findNearbyNotesLimit: Int
    }
    
    let id: String
    let metadata: Metadata
}
