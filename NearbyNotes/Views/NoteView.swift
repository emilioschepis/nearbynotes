//
//  NoteView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 10/12/23.
//

import CoreLocation
import Factory
import SwiftUI

struct NoteView: View {
    @InjectedObject(\.authenticationManager) private var authenticationManager
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: NoteViewModel
    @State private var isFront = true
    @State private var frontRotation: CGFloat = 0
    @State private var backRotation: CGFloat = 90
    @State private var isDeleting = false
    private let duration: TimeInterval = 0.2
    
    let note: Note
    
    init(note: Note) {
        self.note = note
        self._vm = StateObject(wrappedValue: NoteViewModel(note: note))
    }
    
    var front: some View {
        ZStack(alignment: .topTrailing) {
            Text(note.content)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Image(systemName: "hand.tap.fill")
        }
        .padding()
        .aspectRatio(1, contentMode: .fit)
        .background(Color.yellow)
        .rotation3DEffect(.degrees(frontRotation), axis: (x: 0, y: 1, z: 0))
    }
    
    var back: some View {
        VStack(alignment: .trailing) {
            if let profile = vm.detailedNote?.profile {
                Text(profile.id)
                    .bold()
                    .font(.caption)
            }
            
            Text(note.createdAt, style: .date)
                .italic()
                .font(.caption)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding()
        .aspectRatio(1, contentMode: .fit)
        .background(Color.yellow)
        .overlay(alignment: .topLeading) {
            if let imageURL = vm.imageURL {
                AsyncImage(
                    url: imageURL,
                    content: { image in
                        image.image?
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 250, maxHeight: 250)
                            .offset(x: -24)
                            .rotationEffect(.degrees(-12))
                        
                    }
                )
            }
        }
        .rotation3DEffect(.degrees(backRotation), axis: (x: 0, y: 1, z: 0))
    }
    
    var body: some View {
        VStack {
            ZStack {
                front
                back
            }
            .foregroundStyle(.black)
            .shadow(radius: 4)
            .onTapGesture {
                isFront = !isFront
                if isFront {
                    withAnimation(.linear(duration: duration / 2)) {
                        backRotation = 90
                    }
                    withAnimation(.linear(duration: duration / 2).delay(duration / 2)) {
                        frontRotation = 0
                    }
                } else {
                    withAnimation(.linear(duration: duration / 2)) {
                        frontRotation = -90
                    }
                    withAnimation(.linear(duration: duration / 2).delay(duration / 2)) {
                        backRotation = 0
                    }
                }
            }
            
            if authenticationManager.currentUser != nil, let likes = vm.detailedNote?.likes  {
                Button {
                    Task {
                        try? await vm.toggleLike()
                    }
                } label: {
                    Label(
                        likes.count == 1 ? "1 like" : "\(likes.count) likes",
                        systemImage: vm.likedByUser ? "heart.fill" : "heart"
                    )
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .navigationTitle("Note detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if vm.createdByUser {
                Menu("Options", systemImage: "ellipsis.circle") {
                    Button("Delete", role: .destructive) {
                        isDeleting = true
                    }
                }
            }
        }
        .task {
            try? await vm.getDetailedNote()
        }
        .confirmationDialog("Are you sure you want to delete this note?", isPresented: $isDeleting, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task {
                    try await vm.deleteNote()
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {
                isDeleting = false
            }
        }
    }
}

#Preview {
    NoteView(note: .example)
}
