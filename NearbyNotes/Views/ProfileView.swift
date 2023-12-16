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
                            Text("Signed in as \(currentUser.id)")
                        }
                    }
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    SignInWithAppleButton { request in
                        request.requestedScopes = [.email]
                    } onCompletion: { result in
                        authenticationManager.handleAuthenticationResult(result)
                    }
                    .fixedSize()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
