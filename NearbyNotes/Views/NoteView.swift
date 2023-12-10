//
//  NoteView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 10/12/23.
//

import CoreLocation
import SwiftUI

struct NoteView: View {
    @StateObject private var vm: NoteViewModel
    @State private var isFront = true
    @State private var frontRotation: CGFloat = 0
    @State private var backRotation: CGFloat = 90
    private let duration: TimeInterval = 0.2
    
    let note: Note
    
    init(note: Note) {
        self.note = note
        self._vm = StateObject(wrappedValue: NoteViewModel(note: note))
    }
    
    var front: some View {
        VStack {
            Text(note.content)
        }
        .frame(maxWidth: 300, maxHeight: 300, alignment: .center)
        .padding()
        .aspectRatio(1, contentMode: .fit)
        .background(Color.yellow)
        .rotation3DEffect(.degrees(frontRotation), axis: (x: 0, y: 1, z: 0))
    }
    
    var back: some View {
        VStack(alignment: .trailing) {
            Spacer()
            
            if let profile = vm.detailedNote?.profile {
                Text(profile.id)
                    .bold()
                    .font(.caption)
            }
            
            Text(note.createdAt, style: .date)
                .italic()
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: 300, maxHeight: 300, alignment: .bottom)
        .padding()
        .aspectRatio(1, contentMode: .fit)
        .background(Color.yellow)
        .rotation3DEffect(.degrees(backRotation), axis: (x: 0, y: 1, z: 0))
    }
    
    var body: some View {
        ZStack {
            front
            back
        }
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
        .task {
            try? await vm.getDetailedNote()
        }
    }
}

#Preview {
    NoteView(note: .example)
}
