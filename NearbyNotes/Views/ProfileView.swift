//
//  ProfileView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 10/12/23.
//

import AuthenticationServices
import Factory
import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @InjectedObject(\.authenticationManager) private var authenticationManager
    
    var body: some View {
        NavigationStack {
            VStack {
                if let currentUser = authenticationManager.currentUser {
                    List {
                        NavigationLink("Your notes", destination: MyNoteListView.init)
                        NavigationLink("Liked notes", destination: LikedNoteListView.init)
                        
                        Section {
                            Button("Sign out") {
                                authenticationManager.signOut()
                            }
                        } footer: {
                            Text("Signed in as \(currentUser.email ?? currentUser.id.uuidString)")
                        }
                    }
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    VStack(spacing: 16) {
                        Text("Welcome")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("Sign in to NearbyNotes to start creating your own notes for others to find!")
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 8) {
                            Label("Create notes", systemImage: "plus.bubble.fill")
                                .foregroundStyle(.tint)
                                .font(.subheadline)
                            Label("Like notes", systemImage: "heart.fill")
                                .foregroundColor(.red)
                                .font(.subheadline)
                        }
                        
                        SignInWithAppleButton { request in
                            request.requestedScopes = [.email]
                        } onCompletion: { result in
                            authenticationManager.handleAuthenticationResult(result)
                        }
                        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                        .fixedSize()
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
