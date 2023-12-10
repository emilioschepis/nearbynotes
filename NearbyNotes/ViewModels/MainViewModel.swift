//
//  MainViewModel.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 10/12/23.
//

import CoreLocation
import Factory
import Foundation

class MainViewModel: ObservableObject {
    @Injected(\.supabase) private var supabase
    
    @Published var notes: [Note] = []
    @Published var selectedNote: Note?
    
    @MainActor func findNearbyNotes(location: CLLocationCoordinate2D) async throws {
        let notes: [Note] = try await supabase.database
            .rpc("find_nearby_notes", params: ["lat": location.latitude, "lon": location.longitude])
            .execute()
            .value
        
        self.notes = notes
    }
}
