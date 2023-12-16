//
//  DetailedNote.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 10/12/23.
//

import CoreLocation
import Foundation

struct DetailedNote: Identifiable, Codable, Equatable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case content
        case location
        case profile
        case likes
    }
    
    static let example = DetailedNote(
        id: UUID().uuidString,
        createdAt: .now,
        content: "Example Note",
        location: .init(coordinates: [9, 45]),
        profile: Profile(id: UUID().uuidString, createdAt: .now),
        likes: [.example]
    )
    
    let id: String
    let createdAt: Date
    let content: String
    let location: Point
    let profile: Profile
    let likes: [Like]
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: location.coordinates[1], longitude: location.coordinates[0])
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
