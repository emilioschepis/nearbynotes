//
//  CreateNoteView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 15/12/23.
//

import SwiftUI

struct CreateNoteView: View {
    enum Field: Hashable {
        case content
    }
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = CreateNoteViewModel()
    @FocusState private var focus: Field?
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Note content", text: $vm.content)
                    .focused($focus, equals: .content)
            }
            .navigationTitle("Create note")
            .toolbar {
                Button("Save") {
                    Task {
                        try? await vm.createNote()
                        dismiss()
                    }
                }
                .disabled(!vm.canCreate)
            }
        }
        .onAppear {
            focus = .content
        }
    }
}

#Preview {
    CreateNoteView()
}
