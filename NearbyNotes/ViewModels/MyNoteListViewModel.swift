//
//  MyNoteListViewModel.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 15/12/23.
//

import CoreLocation
import Factory
import Foundation
import MapKit

class MyNoteListViewModel: ObservableObject {
    @Injected(\.authenticationManager) private var authenticationManager
    @Injected(\.supabase) private var supabase
    
    @Published var notes: [Note] = []
    
    @MainActor func getNotes() async throws {
        self.notes = try await supabase.database
            .from("notes")
            .select()
            .eq("profile_id", value: authenticationManager.currentUser?.id ?? "")
            .is("deleted_at", value: "null")
            .order("created_at", ascending: false)
            .execute()
            .value
    }
}
