//
//  RootView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 09/12/23.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    RootView()
}
