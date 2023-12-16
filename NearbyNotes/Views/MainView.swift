//
//  MainView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 09/12/23.
//

import Factory
import SwiftUI

struct MainView: View {
    @InjectedObject(\.authenticationManager) private var authenticationManager
    @InjectedObject(\.locationManager) private var locationManager
    @StateObject private var vm = MainViewModel()
    
    @State private var isCreating = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                MapView(
                    radius: vm.configuration?.metadata.findNearbyNotesDistance ?? 0,
                    notes: vm.notes,
                    selectedNote: $vm.selectedNote
                )
                
                if authenticationManager.currentUser != nil {
                    Button {
                        isCreating = true
                    } label: {
                        Label("Create note", systemImage: "plus.bubble.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
            .navigationDestination(item: $vm.selectedNote, destination: NoteView.init)
            .sheet(isPresented: $isCreating, content: CreateNoteView.init)
            .task {
                try? await vm.getConfiguration()
            }
            .task(id: locationManager.location) {
                if let location = locationManager.location {
                    try? await vm.findNearbyNotes(location: location)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
