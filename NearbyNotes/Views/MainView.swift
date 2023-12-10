//
//  MainView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 09/12/23.
//

import Factory
import SwiftUI

struct MainView: View {
    @InjectedObject(\.locationManager) private var locationManager
    @StateObject private var vm = MainViewModel()
    
    var body: some View {
        MapView(
            radius: vm.configuration?.metadata.findNearbyNotesDistance ?? 0,
            notes: vm.notes,
            selectedNote: $vm.selectedNote
        )
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

#Preview {
    MainView()
}
