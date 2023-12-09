//
//  NearbyNotesApp.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 09/12/23.
//

import Factory
import Supabase
import SwiftUI

@main
struct NearbyNotesApp: App {
    @Injected(\.supabase) private var supabase
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

extension Container {
    var supabase: Factory<SupabaseClient> {
        let supabaseURL = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as! String
        let supabaseKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_KEY") as! String
        
        return Factory(self) { SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey) }.singleton
    }
}
