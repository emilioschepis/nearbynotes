//
//  AuthenticationManager.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 10/12/23.
//

import AuthenticationServices
import Factory
import Foundation
import Supabase

class AuthenticationManager: ObservableObject {
    @Injected(\.supabase) private var supabase
    
    @Published var currentUser: User?
    
    init() {
        Task { @MainActor in
            currentUser = try? await supabase.auth.session.user
            
            for await (_, session) in await supabase.auth.authStateChanges {
                currentUser = session?.user
            }
        }
    }
    
    func handleAuthenticationResult(_ result: Result<ASAuthorization, Error>) {
        Task { @MainActor in
            guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential else {
                return
            }
            
            guard let idToken = credential.identityToken.flatMap({ String(data: $0, encoding: .utf8) }) else {
                return
            }
            
            let session = try await supabase.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idToken))
            currentUser = session.user
        }
    }
    
    func signOut() {
        Task { @MainActor in
            try await supabase.auth.signOut(scope: .local)
        }
    }
}
