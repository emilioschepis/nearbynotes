//
//  MyNoteListView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 15/12/23.
//

import SwiftUI

struct MyNoteListView: View {
    @StateObject private var vm = MyNoteListViewModel()
    
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
    MyNoteListView()
}
