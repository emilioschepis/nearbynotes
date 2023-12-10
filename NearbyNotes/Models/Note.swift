//
//  Note.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 10/12/23.
//

import CoreLocation
import Foundation

struct Note: Identifiable, Codable, Equatable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case content
        case location
    }
    
    let id: String
    let createdAt: Date
    let content: String
    let location: Point
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: location.coordinates[1], longitude: location.coordinates[0])
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
