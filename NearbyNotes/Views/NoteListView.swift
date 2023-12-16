//
//  NoteListView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 15/12/23.
//

import SwiftUI

struct NoteListView: View {
    @StateObject private var vm = NoteListViewModel()
    
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
        .task {
            try? await vm.getNotes()
        }
    }
}

#Preview {
    NoteListView()
}
