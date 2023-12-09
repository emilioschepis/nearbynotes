//
//  RootView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 09/12/23.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        VStack {
            Image(systemName: "bolt.fill")
                .imageScale(.large)
                .foregroundStyle(.green)
            Text("Hello, Supabase!")
        }
        .padding()
    }
}

#Preview {
    RootView()
}
