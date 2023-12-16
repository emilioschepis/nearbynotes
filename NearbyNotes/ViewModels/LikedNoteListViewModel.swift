//
//  LikedNoteListViewModel.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 16/12/23.
//

import CoreLocation
import Factory
import Foundation
import MapKit

class LikedNoteListViewModel: ObservableObject {
    @Injected(\.authenticationManager) private var authenticationManager
    @Injected(\.supabase) private var supabase
    
    @Published var notes: [Note] = []
    
    @MainActor func getNotes() async throws {
        self.notes = try await supabase.database
            .from("notes")
            .select("*, likes!inner(profile_id)")
            .eq("likes.profile_id", value: authenticationManager.currentUser?.id ?? "")
            .order("created_at", ascending: false)
            .execute()
            .value
    }
}
