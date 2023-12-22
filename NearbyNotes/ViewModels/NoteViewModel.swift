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
    @Injected(\.authenticationManager) private var authenticationManager
    @Injected(\.supabase) private var supabase
    
    let note: Note
    @Published var detailedNote: DetailedNote?
    
    var likedByUser: Bool {
        detailedNote?.likes.contains { $0.profileId.lowercased() == authenticationManager.currentUser?.id.uuidString.lowercased() } ?? false
    }
    
    var imageURL: URL? {
        guard let filePath = detailedNote?.image else {
            return nil
        }
        
        return try? supabase.storage.from("images").getPublicURL(path: filePath)
    }
    
    init(note: Note) {
        self.note = note
    }
    
    @MainActor func getDetailedNote() async throws {
        let detailedNote: DetailedNote = try await supabase.database
            .from("notes")
            .select("*, profile:public_profiles(id, created_at), likes(profile_id, created_at)")
            .eq("id", value: note.id)
            .single()
            .execute()
            .value
        
        self.detailedNote = detailedNote
    }
    
    @MainActor func toggleLike() async throws {
        guard let userId = authenticationManager.currentUser?.id else {
            return
        }
        
        if likedByUser {
            try await supabase.database
                .from("likes")
                .delete()
                .match(["profile_id": userId.uuidString, "note_id": note.id])
                .execute()
        } else {
            try await supabase.database
                .from("likes")
                .insert(["profile_id": userId.uuidString, "note_id": note.id])
                .execute()
        }
        
        try await getDetailedNote()
    }
}
