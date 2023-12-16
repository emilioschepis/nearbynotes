//
//  CreateNoteViewModel.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 15/12/23.
//

import Factory
import Foundation

class CreateNoteViewModel: ObservableObject {
    @Injected(\.supabase) private var supabase
    @Injected(\.authenticationManager) private var authenticationManager
    @Injected(\.locationManager) private var locationManager
    
    @Published var content = ""
    
    var canCreate: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        authenticationManager.currentUser != nil &&
        locationManager.location != nil
    }
    
    @MainActor func createNote() async throws {
        guard let profileId = authenticationManager.currentUser?.id.uuidString else {
            return
        }
        
        guard let location = locationManager.location else {
            return
        }
        
        try await supabase.database
            .from("notes")
            .insert([
                "content": content,
                "profile_id": profileId,
                "location": "SRID=4326;POINT(\(location.longitude) \(location.latitude))"
            ])
            .execute()
    }
}
