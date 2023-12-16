//
//  LikedNoteListView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 16/12/23.
//

import SwiftUI

struct LikedNoteListView: View {
    @StateObject private var vm = LikedNoteListViewModel()
    
    var body: some View {
        List(vm.notes) { note in
            NavigationLink(destination: NoteView(note: note)) {
                VStack(alignment: .leading) {
                    Text(note.content)
                    Text(note.createdAt, style: .date)
                        .font(.caption)
                }
            }
        }
        .navigationTitle("Liked notes")
        .task {
            try? await vm.getNotes()
        }
    }
}

#Preview {
    LikedNoteListView()
}
