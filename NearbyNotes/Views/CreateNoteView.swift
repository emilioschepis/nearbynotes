//
//  CreateNoteView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 15/12/23.
//

import PhotosUI
import SwiftUI

struct CreateNoteView: View {
    enum Field: Hashable {
        case content
    }
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var mainVM: MainViewModel
    @StateObject private var vm = CreateNoteViewModel()
    @FocusState private var focus: Field?
    
    @State private var previewImageData: Data?
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Note content", text: $vm.content)
                    .focused($focus, equals: .content)
                
                PhotosPicker("Attach an image", selection: $vm.image, matching: .images)
                
                if let previewImageData, let previewImage = UIImage(data: previewImageData) {
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
            }
            .navigationTitle("Create note")
            .toolbar {
                Button("Save") {
                    Task {
                        try? await vm.createNote()
                        mainVM.needsRefetch.send(())
                        dismiss()
                    }
                }
                .disabled(!vm.canCreate)
            }
            .onChange(of: vm.image) {
                Task {
                    if let loaded = try? await vm.image?.loadTransferable(type: Data.self) {
                        previewImageData = loaded
                    }
                    
                }
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
