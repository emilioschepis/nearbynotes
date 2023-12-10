//
//  NoteViewModel.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 10/12/23.
//

import CoreLocation
import Factory
import Foundation
import MapKit

class NoteViewModel: ObservableObject {
    @Injected(\.supabase) private var supabase
    
    let note: Note
    @Published var detailedNote: DetailedNote?
    
    init(note: Note) {
        self.note = note
    }
    
    @MainActor func getDetailedNote() async throws {
        let detailedNote: DetailedNote = try await supabase.database
            .from("notes")
            .select("*, profile:public_profiles(id, created_at)")
            .eq("id", value: note.id)
            .single()
            .execute()
            .value
        
        self.detailedNote = detailedNote
    }
}
